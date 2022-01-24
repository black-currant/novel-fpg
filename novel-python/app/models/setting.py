from datetime import datetime
from app.core import db
from . import base

class Setting(db.Model, base.BaseModel):
    __tablename__ = 'sys_setting'
    
    id = db.Column(db.Integer, primary_key=True)
    source = db.Column(db.String(32))
    name = db.Column(db.String(32))
    option = db.Column(db.String(32))
    status = db.Column(db.SmallInteger, default=0)
    create_time = db.Column(db.DateTime, default=datetime.now)
    update_time = db.Column(db.DateTime, default=datetime.now)