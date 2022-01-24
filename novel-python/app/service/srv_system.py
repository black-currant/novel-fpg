from app.core import ResponseCode, db, cache, get_global
from app.models import base

@cache.memoize(timeout=3600)
def hot_keywords(num):
    '''
    获取热搜关键词
    '''
    sql = f"SELECT keyword, COUNT(*) cnt FROM sys_keywords GROUP BY keyword ORDER BY COUNT(*) DESC LIMIT {num}"
    results = base.query(sql)
    results = [x['keyword'] for x in results]
    return ResponseCode.Success, results

@cache.memoize(timeout=3600)
def get_categories():
    '''
    获取书籍类目
    '''
    sql = f"SELECT * FROM sys_category WHERE book_cnt > 0"
    results = base.query(sql)
    return ResponseCode.Success, results