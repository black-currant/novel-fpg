import datetime
import decimal
import logging
import uuid
import time

from flask import request, current_app, json
from flask_sqlalchemy import SQLAlchemy
from flask_caching import Cache
from flask_redis import FlaskRedis

from app.common import util

db = SQLAlchemy()
cache = Cache()
r = FlaskRedis()
logger = logging.getLogger(__name__)
GLOBAL_DICT = {}

class ResponseCode(object):
    Success = 0                   # 成功
    Fail = 10000                  # 失败
    TokenMissing = 20001          # Token缺失
    TokenExpired = 20002          # Token已过期
    TokenError = 20003            # Token错误
    UserNotFound = 30001          # 用户不存在
    PasswordError = 30002         # 密码错误
    InvalidParameter = 40001      # 参数无效
    ObjectNotFound = 40002        # 对象不存在
    ObjectExisted = 40003         # 对象已存在
    InternalServerError = 50001   # 服务器内部错误
    QuestFinished = 60001         # 任务已完成
    QuestTypeError = 60002        # 任务类型有误


class JSONEncoder(json.JSONEncoder):

    def default(self, o):
        """
        如有其他的需求可直接在下面添加
        :param o:
        :return:
        """
        if isinstance(o, datetime.datetime):
            # 格式化时间
            return o.strftime("%Y-%m-%d %H:%M:%S")
        if isinstance(o, datetime.date):
            # 格式化日期
            return o.strftime('%Y-%m-%d')
        if isinstance(o, decimal.Decimal):
            # 格式化高精度数字
            return str(o)
        if isinstance(o, uuid.UUID):
            # 格式化uuid
            return str(o)
        if isinstance(o, bytes):
            # 格式化字节数据
            return o.decode("utf-8")
        return super(JSONEncoder, self).default(o)

def ResMsg(data=None, code=ResponseCode.Success, rq=request):
    """
    输出响应文本
    """
    # 获取请求中语言选择,默认为英文
    lang = rq.headers.get("Accept-Language", current_app.config.get("LANG", "zh-CN"))
    lang = lang.replace('_', '-')
    if lang != 'en-US':
        lang = 'zh-CN'
    body = {
        'code': code,
        'message': current_app.config[lang].get(code, ''),
        'data': data
    }
    return body

def set_global(key, value):
    GLOBAL_DICT[key] = value

def get_global(key, value=None):
    try:
        return GLOBAL_DICT[key]
    except KeyError:
        return value

def make_response(actual_do):
    def wrapper(*args, **kwargs):
        try:
            client_ip = util.get_clientip(request)
            aid = 0
            if request.method == 'GET':
                data = request.args
            else:
                data = request.json
                # data = request.stream.read()
                # data = json.loads(data, strict=False)
            action = data.get('action', '')
            token = request.headers.get('Access-Token')
            token_dict = util.parse_token(token, current_app.config['TOKEN_KEY'])
            aid = token_dict.get('aid', 0)
            logger.info("[%s] [%s] [%s] %s %s: ", client_ip, aid, actual_do.__name__, action, json.dumps(data, ensure_ascii=False, indent=4))
            
            if action not in ['sys_config', 'login', 'auth']:
                if not token:
                    body = ResMsg(code=ResponseCode.TokenMissing)
                elif not token_dict:
                    body = ResMsg(code=ResponseCode.TokenError)
                elif token_dict['exp'] < int(time.time()):
                    body = ResMsg(code=ResponseCode.TokenExpired)
                else:
                    code, results = actual_do(data, aid=aid)
                    body = ResMsg(code=code, data=results)
            else:
                code, results = actual_do(data, aid=aid)
                body = ResMsg(code=code, data=results)
        except Exception as e:
            logger.exception('%s, %s', actual_do.__name__, e)
            body = ResMsg(code=ResponseCode.InternalServerError)
        finally:
            logger.info("[%s] [%s] [%s] %s %s: ", client_ip, aid, actual_do.__name__, action, json.dumps(body, ensure_ascii=False, indent=4))
            return body

    return wrapper