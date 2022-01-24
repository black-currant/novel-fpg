from datetime import datetime
from app.core import db
from . import base

class ReadLog(db.Model, base.BaseModel):
    __tablename__ = 'usr_read_log'
    
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer)
    bid = db.Column(db.Integer)
    duration = db.Column(db.Integer)
    create_time = db.Column(db.DateTime, default=datetime.now)