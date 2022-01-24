from app.core import ResponseCode, db, cache, get_global, make_response
from app.common import util
from app.models import account
from app.models.account import Account
from app.models.quest import Quest
from app.models.score import Score
from app.models.read_log import ReadLog
from app.models.user_chapter import UserChapter
from app.models.setting import Setting
from app.models import base
from app.service import srv_user
from app.service import srv_book
from app.service import srv_system
from . import v10

from werkzeug.security import generate_password_hash, check_password_hash
from flask import request, current_app, json
import datetime
import asyncio
import logging
import random
import time
import copy
import sys

import nest_asyncio
nest_asyncio.apply()

logger = logging.getLogger(__name__)
loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)

@v10.route('/', methods=["POST"], endpoint="server")
@make_response
def server(data, aid):
    """
    按方法名动态执行函数
    :param data: 参数
    :param aid: 用户ID
    """
    action = data.get('action', '')
    if not action:
        logger.error('no action: %s', data)
        return ResponseCode.InvalidParameter, None

    mod = sys.modules[__name__]
    func = getattr(mod, action)
    return func(data.get('data', {}), aid)

def login(data, aid):
    '''
    账号密码登陆
    '''
    username = data.get('username', '')
    password = data.get('password', '')
    deviceid = data.get('deviceid', '')
    os = data.get('os', '')
    os_version = data.get('os_version', '')
    device_mode = data.get('device_mode', '')
    app_version = data.get('app_version', '')
    country = data.get('country', '').upper()
    if not username or not password:
        logger.error("no username or no password: %s", data)
        return ResponseCode.InvalidParameter, None

    register = 0
    user = Account.query.filter_by(account=username).first()
    if not user:
        register = 1
        password = generate_password_hash(password)
        user = Account(username, password, deviceid)
        db.session.add(user)
        db.session.flush()
    elif not check_password_hash(user.password, password):
        return ResponseCode.PasswordError, None
    
    user.os = os
    user.os_version = os_version
    user.device_mode = device_mode
    user.app_version = app_version
    user.country = country
    return srv_user.login_success(user, register)

def auth(data, aid):
    '''
    第三方平台授权登陆
    '''
    uid = data.get('uid', 0)
    provider = data.get('provider', '')
    pid = data.get('pid', '')
    nickname = data.get('nickname', '')
    gender = data.get('gender', '0')
    phone = data.get('phone', '')
    email = data.get('email', '')
    photourl = data.get('photourl', '')
    deviceid = data.get('deviceid', '')
    os = data.get('os', '')
    os_version = data.get('os_version', '')
    device_mode = data.get('device_mode', '')
    app_version = data.get('app_version', '')
    country = data.get('country', '').upper()
    if not provider or not pid:
        return ResponseCode.InvalidParameter, None

    register = 0
    user = Account.query.filter_by(provider=provider, pid=pid).first()
    if not user:
        register = 1
        user = Account.auth(provider, pid, nickname, gender, phone, email, photourl, deviceid)
        db.session.add(user)
        db.session.flush()
    
    user.os = os
    user.os_version = os_version
    user.device_mode = device_mode
    user.app_version = app_version
    user.country = country
    return srv_user.login_success(user, register, uid)

def mod_info(data, aid):
    '''
    修改用户信息
    '''
    user = Account.query.filter_by(id=aid)
    user_obj = user.first()
    if not user_obj:
        return ResponseCode.UserNotFound, None

    # 过滤非法字段
    filter_list = ['id', 'account', 'password', 'vip', 'viptime', 'score', 'logtime', 'status']
    for x in filter_list:
        if x in data:
            del data[x]
    result = user.update(data)
    db.session.commit()
    if result == 1:
        return ResponseCode.Success, {}
    else:
        return ResponseCode.Fail, None

def bind_list(data, aid):
    '''
    获取子账号列表
    '''
    user_id = data.get('id', 0)
    if not user_id:
        return ResponseCode.InvalidParameter, None

    results = Account.query.filter_by(main_id=user_id).all()
    results = [x.to_dict() for x in results]
    return ResponseCode.Success, results

def get_info(data, aid):
    '''
    获取用户信息
    '''
    user = Account.query.filter_by(id=aid).first()
    if not user:
        return ResponseCode.UserNotFound, None
    
    results = user.to_dict()
    del results['password']
    return ResponseCode.Success, results

def book_list(data, aid):
    '''
    获取书籍列表
    '''
    bid = data.get('bid', '')
    flag = data.get('flag', '')
    keywords = data.get('keywords', '')
    start_time = data.get('start_time', 0)
    value = data.get('value', 0)
    order = data.get('order', '')
    page = data.get('page', 0)
    num = data.get('num', current_app.config['DEFAULT_PAGE_SIZE'])

    return srv_book.search_book(bid, flag, keywords, start_time, value, order, page, num)

def get_favorites(data, aid):
    '''
    获取书架
    '''
    sql = f"SELECT b.* FROM usr_favorites a JOIN res_book b ON a.bid = b.id WHERE a.uid = {aid} AND a.`status` = 1"
    results = base.query(sql)
    return ResponseCode.Success, results

def set_favorites(data, aid):
    '''
    收藏书籍
    '''
    bids = data.get('bids', [])
    status = data.get('status', '')
    if not bids or status == '':
        return ResponseCode.InvalidParameter, None

    for x in bids:
        sql = f"INSERT INTO usr_favorites(uid, bid, `status`) VALUES ({aid}, {x}, {status}) ON DUPLICATE KEY UPDATE `status` = {status}, update_time = CURRENT_TIMESTAMP"
        db.session.execute(sql)
    db.session.commit()
    return ResponseCode.Success, {}

def hot_keywords(self, data):
    '''
    获取热搜关键词
    '''
    num = data.get('num', current_app.config['DEFAULT_PAGE_SIZE'])
    return srv_system.hot_keywords(num)

def get_categories(data, aid):
    '''
    获取书籍类目
    '''
    return srv_system.get_categories()

def quest_list(data, aid):
    '''
    获取任务列表
    '''
    quest_res = Quest.query.filter_by(uid=aid).all()
    quest_dict = {x.tid: x for x in quest_res}
    results = []
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    QUEST_TPL = get_global('quest_tpl')
    for index, row in QUEST_TPL.iterrows():
        quest_doing = copy.copy(row)
        params = str(quest_doing['Param']).split('|')
        quest_obj = quest_dict.get(quest_doing['Task ID'])
        if quest_obj:
            if quest_doing['Task Type'] == 'daily': #每日任务
                if quest_obj.update_time.strftime("%Y-%m-%d") != today:
                    quest_obj.status = 0
                    quest_obj.update_time = datetime.datetime.now()
            elif quest_doing['Task Type'] == 'loop': #日环任务
                if quest_obj.update_time.strftime("%Y-%m-%d") != today:
                    if quest_obj.progress + 1 >= len(params) or (datetime.datetime.now() - quest_obj.update_time).days > 1:
                        quest_obj.progress = 0
                    else:
                        quest_obj.progress += 1
                    quest_obj.status = 0
                    quest_obj.update_time = datetime.datetime.now()
            elif quest_doing['Task Type'] == 'weekly': #每周任务
                if datetime.datetime.now().isocalendar()[1] > quest_obj.update_time.isocalendar()[1]:
                    quest_obj.status = 0
                    quest_obj.progress = 0
                    quest_obj.update_time = datetime.datetime.now()

        quest_doing['status'] = quest_obj.status if quest_obj else 0
        quest_doing['progress'] = quest_obj.progress if quest_obj else 0
        results.append(quest_doing.to_dict())

    db.session.commit()
    return ResponseCode.Success, results

def quest_reward(data, aid):
    '''
    领取任务奖励
    '''
    tid = data.get('tid', '')
    if not tid:
        return ResponseCode.InvalidParameter, None

    user = Account.query.filter_by(id=aid).first()
    if not user:
        return ResponseCode.UserNotFound, None

    return srv_user.quest_reward(user, tid)

def read_log(data, aid):
    '''
    上报阅读记录
    '''
    duration = data.get('duration', 0)
    if not duration:
        return ResponseCode.InvalidParameter, None

    user = Account.query.filter_by(id=aid).first()
    if not user:
        return ResponseCode.UserNotFound, None 

    QUEST_TPL = get_global('quest_tpl')
    tid = 'task.read.duration'
    quest_tpl = QUEST_TPL[QUEST_TPL['Task ID']==tid]
    params = str(quest_tpl[['Param']].values[0, 0]).split('|')
    score_list = quest_tpl[['Virtual Currency']].values[0, 0].split('|')
    quest_obj = Quest.query.filter(Quest.uid==aid, Quest.tid==tid).first()
    user.duration += duration
    progress = -1 if quest_obj == None else quest_obj.progress
    for i in range(progress + 1, len(params)):
        if user.duration >= int(params[i]):
            score = int(score_list[i])
            score_before = user.score
            user.score = score_before + score
            score_flow = Score(uid=aid, score=score, score_before=score_before, score_after=user.score, source_id=tid, remark='阅读奖励')
            db.session.add(score_flow)
            if quest_obj == None:
                quest_obj = Quest(uid=aid, tid=tid, status=1, progress=i)
                quest_obj.save()
            else:
                quest_obj.status = 1
                quest_obj.progress = i
                quest_obj.update_time = datetime.datetime.now()
    log = ReadLog(**data)
    log.save()
    results = {'score':user.score, 'duration':user.duration}
    return ResponseCode.Success, results

def check_message(data, aid):
    '''
    检查消息
    '''
    return ResponseCode.Success, []

def score_flow(data, aid):
    '''
    获取书币流水
    '''
    page = data.get('page', 0)
    num = data.get('num', current_app.config['DEFAULT_PAGE_SIZE'])
    results = Score.query.filter_by(uid=aid).order_by(Score.create_time.desc()).offset(page*num).limit(num)
    results = [x.to_dict() for x in results]
    return ResponseCode.Success, results

def buy_chapter(data, aid):
    '''
    购买章节
    '''
    book_id = data.get('bid', 0)
    chapter_id = data.get('cid', 0)
    score = data.get('score', 0)
    if not book_id or not chapter_id:
        return ResponseCode.InvalidParameter, None

    user = Account.query.filter_by(id=aid).first()
    if not user:
        return ResponseCode.UserNotFound, None

    if score > 0:
        score = -score
        score_before = user.score
        user.score = score_before + score
        score_flow = Score(uid=aid, score=score, score_before=score_before, score_after=user.score, source_id=chapter_id, remark='购买章节')
        db.session.add(score_flow)

        buy_obj = UserChapter(uid=aid, bid=book_id, cid=chapter_id)
        buy_obj.save()

    results = {'score': user.score}
    return ResponseCode.Success, results

def user_chapter(data, aid):
    '''
    获取用户已购买章节
    '''
    book_id = data.get('bid', 0)
    if not book_id:
        return ResponseCode.InvalidParameter, None

    results = UserChapter.query.filter_by(uid=aid, bid=book_id).all()
    results = [x.cid for x in results]
    return ResponseCode.Success, results

def sys_config(data, aid):
    '''
    获取系统设置
    '''
    results = Setting.query.filter_by(source='server', status=1).all()
    results = [x.to_dict() for x in results]
    return ResponseCode.Success, results