from app.core import db
from . import base

class Category(db.Model, base.BaseModel):
    __tablename__ = 'sys_category'
    
    id = db.Column(db.Integer, primary_key=True)
    value = db.Column(db.Integer)
    category = db.Column(db.String(32))
    image = db.Column(db.Text)
    book_cnt = db.Column(db.Integer)
    code = db.Column(db.String(32))

    def __repr__(self):
        return self.category