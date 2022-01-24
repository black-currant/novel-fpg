from datetime import datetime
from app.core import db
from . import base

class Book(db.Model, base.BaseModel):
    __tablename__ = 'res_book'
    
    id = db.Column(db.Integer, primary_key=True)
    bid = db.Column(db.String(64), default='')
    title = db.Column(db.String(256))
    image = db.Column(db.Text)
    category = db.Column(db.String(32), default='')
    author = db.Column(db.String(128))
    chapter_cnt = db.Column(db.Integer, default=0)
    intro = db.Column(db.Text)
    flag = db.Column(db.String(32), default='0')
    free = db.Column(db.SmallInteger, default=0)
    value = db.Column(db.Integer, default=0)
    free_chapter_cnt = db.Column(db.Integer, default=0)
    chapter_cost = db.Column(db.Integer, default=0)
    tags = db.Column(db.String(255), default='')
    recent_chapter = db.Column(db.String(128), default='')
    catalog_link = db.Column(db.String(128), default='')
    words_cnt = db.Column(db.Integer, default=0)
    status = db.Column(db.SmallInteger, default=0)
    create_time = db.Column(db.DateTime, default=datetime.now)
    update_time = db.Column(db.DateTime, default=datetime.now)

    def __init__(self, title, author, source):
        self.title = title
        self.author = author
        self.source = source

    def __repr__(self):
        return self.title