from app.core import ResponseCode, db, cache, get_global
from app.common import util
from app.models.account import Account
from app.models.quest import Quest
from app.models.score import Score

from flask import request, current_app
import datetime


def login_success(user, register=0, uid=0):
    '''
    登陆后处理
    '''
    if uid:
        # 绑定主账号
        user.main_id = uid
        tid = 'task.bind.{}'.format(user.provider)
        # 发放绑定账号任务奖励
        user = Account.query.filter_by(id=uid).first()
        quest_reward(user, tid)
    elif user.main_id:
        # 自动切换到主账号
        user = Account.query.filter_by(id=user.main_id).first()
    elif register == 1:
        # 发放新注册用户奖励
        tid = 'task.bind.{}'.format(user.provider)
        quest_reward(user, tid)

    today = datetime.datetime.now()
    if today.isocalendar()[1] > user.logtime.isocalendar()[1]:
        # 每周阅读时长
        user.duration = 0
    user.logip = util.get_clientip(request)
    user.logtime = today
    ret = user.to_dict()
    del ret['password']
    db.session.commit()
    ret['register'] = register
    ret['token'] = util.get_token(user.id, 'app', current_app.config['TOKEN_KEY'], current_app.config['TOKEN_EXPIRE_TIME'])
    return ResponseCode.Success, ret

def quest_reward(user, tid):
    '''
    领取任务奖励
    '''
    QUEST_LIST = get_global('quest_tpl')
    quest_tpl = QUEST_LIST[QUEST_LIST['Task ID']==tid]
    if quest_tpl.empty:
        return ResponseCode.ObjectNotFound, None

    quest_type = quest_tpl[['Task Type']].values[0, 0]
    quest_obj = Quest.query.filter(Quest.uid==user.id, Quest.tid==tid).first()
    if quest_type == 'newbie':
        if quest_obj:
            return ResponseCode.QuestFinished, None
    elif quest_type == 'daily':
        if quest_obj and quest_obj.status == 1:
            return ResponseCode.QuestFinished, None
    elif quest_type == 'loop':
        if quest_obj and quest_obj.status == 1:
            return ResponseCode.QuestFinished, None
    else:
        return ResponseCode.QuestTypeError, None
    
    if not quest_obj:
        quest_obj = Quest(uid=user.id, tid=tid, status=1, progress=0)
        db.session.add(quest_obj)
    else:
        quest_obj.status = 1
        quest_obj.update_time = datetime.datetime.now()

    score = quest_tpl[['Virtual Currency']].values[0, 0]
    score = score.split('|')[quest_obj.progress]
    score_before = user.score
    user.score = score_before + int(score)
    score_after = user.score
    remark = quest_tpl[['Locale; Title; Description']].values[0, 0].split('; ')[1]
    score_flow = Score(uid=user.id, score=score, score_before=score_before, score_after=score_after, source_id=tid, remark=remark)
    db.session.add(score_flow)
    db.session.commit()
    results = {'score': score_after}
    return ResponseCode.Success, results
