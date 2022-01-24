from app.core import db
from . import base

class Chapter(db.Model, base.BaseModel):
    __tablename__ = 'res_chapter'
    
    id = db.Column(db.Integer, primary_key=True)
    cid = db.Column(db.String(64))
    title = db.Column(db.String(256))
    content = db.Column(db.Text)
    bid = db.Column(db.String(64))
    btitle = db.Column(db.String(256))
    author = db.Column(db.String(128))
    idx = db.Column(db.Integer)
    words_cnt = db.Column(db.Integer)
    status = db.Column(db.SmallInteger)
    create_time = db.Column(db.DateTime)
    update_time = db.Column(db.DateTime)

    def __repr__(self):
        return self.title