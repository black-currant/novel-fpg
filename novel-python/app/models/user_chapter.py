from datetime import datetime
from app.core import db
from . import base

class UserChapter(db.Model, base.BaseModel):
    __tablename__ = 'usr_chapter'
    
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer)
    bid = db.Column(db.Integer)
    cid = db.Column(db.Integer)
    create_time = db.Column(db.DateTime, default=datetime.now)