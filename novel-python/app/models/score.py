from datetime import datetime
from app.core import db
from . import base

class Score(db.Model, base.BaseModel):
    __tablename__ = 'usr_score'
    
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer)
    score = db.Column(db.Integer)
    score_before = db.Column(db.Integer)
    score_after = db.Column(db.Integer)
    source_id = db.Column(db.String(32))
    remark = db.Column(db.String(255))
    create_time = db.Column(db.DateTime, default=datetime.now)