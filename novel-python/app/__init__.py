import logging
import logging.config
import pandas as pd
import yaml
import os
import redis_lock
from elasticsearch import Elasticsearch, AsyncElasticsearch
from flask import Flask, Blueprint
from flask_cors import CORS

from app.core import JSONEncoder, db, cache, r, set_global
from app.api import routers


def create_app(config_name, config_path=None):
    app = Flask(__name__)
    pwd = os.getcwd()
    # 配置文件路径
    if not config_path:
        config_path = os.path.join(pwd, 'config/config.yaml')

    # 读取配置文件
    with open(config_path, 'r', encoding='utf-8') as f:
        conf = yaml.safe_load(f.read())
    app.config.update(conf[config_name or 'PRODUCTION'])

    # 注册路由
    for router_api in routers:
        if isinstance(router_api, Blueprint):
            app.register_blueprint(router_api)

    # 注册数据库连接
    db.app = app
    db.init_app(app)

    # 注册缓存连接
    cache.init_app(app, config=app.config['CACHE_CONFIG'])
    r.init_app(app)
    redis_lock.reset_all(r)

    # 注册ES
    set_global('es', Elasticsearch(**app.config['ELASTICSEARCH_URI']))
    set_global('async_es', AsyncElasticsearch(**app.config['ELASTICSEARCH_URI']))

    # 日志文件目录
    if not os.path.exists(app.config['LOGGING_PATH']):
        os.mkdir(app.config['LOGGING_PATH'])

    # 日志设置
    with open(app.config['LOGGING_CONFIG_PATH'], 'r', encoding='utf-8') as f:
        dict_conf = yaml.safe_load(f.read())
    logging.config.dictConfig(dict_conf)

    # 加载任务配置模板表
    cvs_file = os.path.join(pwd, app.config['QUEST_PATH'])
    df = pd.read_csv(cvs_file).sort_values(by=['Task ID'])
    df = df[df['Task State']=='published']
    set_global('quest_tpl', df.fillna(''))

    # 读取I18N配置
    with open(app.config['I18N_PATH'], 'r', encoding='utf-8') as f:
        msg = yaml.safe_load(f.read())
        app.config.update(msg)

    # 返回json格式转换
    app.json_encoder = JSONEncoder
    
    # 跨域设置
    CORS(app, resources=r'/*', supports_credentials=True)

    return app