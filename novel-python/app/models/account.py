from datetime import datetime
from app.core import db
from . import base

class Account(db.Model, base.BaseModel):
    __tablename__ = 'usr_account'

    id = db.Column(db.Integer, primary_key=True)
    account = db.Column(db.String(64), default='')
    password = db.Column(db.String(255), default='')
    nickname = db.Column(db.String(64), default='')
    gender = db.Column(db.String(16), default='0')
    phone = db.Column(db.String(20), default='')
    email = db.Column(db.String(64), default='')
    photourl = db.Column(db.String(255), default='')
    deviceid = db.Column(db.String(64), default='')
    os = db.Column(db.String(32), default='')
    os_version = db.Column(db.String(32), default='')
    device_mode = db.Column(db.String(255), default='')
    app_version = db.Column(db.String(32), default='')
    country = db.Column(db.String(32), default='')
    provider = db.Column(db.String(64), default='')
    pid = db.Column(db.String(64), default='')
    vip = db.Column(db.SmallInteger, default=0)
    viptime = db.Column(db.DateTime)
    score = db.Column(db.Integer, default=1000)
    duration = db.Column(db.Integer, default=0)
    preference = db.Column(db.Integer, default=0)
    main_id = db.Column(db.Integer, default=0)
    logip = db.Column(db.String(32), default='')
    logtime = db.Column(db.DateTime, default=datetime.now)
    status = db.Column(db.SmallInteger, default=1)

    # 主构造函数
    def __init__(self, account, password, deviceid):
        self.id = base.get_obj_id()
        self.account = account
        self.password = password
        self.deviceid = deviceid
        self.nickname = account
        self.email = account

    # 可选构造函数
    @classmethod
    def auth(cls, provider, pid, nickname, gender, phone, email, photourl, deviceid):
        user = cls('', '', deviceid)
        user.provider = provider
        user.pid = pid
        user.nickname = nickname
        user.gender = gender
        user.phone = phone
        user.email = email
        user.photourl = photourl
        return user

    def __repr__(self):
        return self.account