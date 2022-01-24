from datetime import datetime
from app.core import db
from . import base

class Quest(db.Model, base.BaseModel):
    __tablename__ = 'usr_quest'
    
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer)
    tid = db.Column(db.String(32))
    status = db.Column(db.SmallInteger, default=0)
    progress = db.Column(db.SmallInteger, default=0)
    create_time = db.Column(db.DateTime, default=datetime.now)
    update_time = db.Column(db.DateTime, default=datetime.now)