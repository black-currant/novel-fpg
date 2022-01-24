from datetime import datetime, date
from app.core import db, r
import redis_lock

def default(o):
    if isinstance(o, datetime):
        return datetime.strftime(o,'%Y-%m-%d %H:%M:%S')

    if isinstance(o, date):
        return datetime.strftime(o,'%Y-%m-%d')

    return o

class BaseModel:
    
    def to_dict(self):
        _dict = {}
        for k in self.__dict__:
            if k.startswith("_sa_"): continue
            _dict[k] = default(self.__dict__[k])

        return _dict

    def save(self):
        db.session.add(self)
        db.session.flush()
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

def query(sql):
    results = db.session.execute(sql)
    results = [{column: value for column, value in rowproxy.items()} for rowproxy in results]
    return results

def get_obj_id():
    '''
        生成全局唯一ID
    '''
    lock = redis_lock.Lock(r._redis_client, 'obj_id')
    if lock.acquire(blocking=True):
        ts = int(datetime.utcnow().timestamp())
        while True:
            redis_key = f'obj_id_{ts}'
            seq = r.incr(redis_key, 1)
            r.expire(redis_key, 30)
            if seq <= 0xFFFFFFFF:
                new_id = ((ts) << 10) | seq
                break
            # 这一秒钟内序列号使用完了，使用下一秒的序列号
            ts += 1
        lock.release()

    return new_id

def get_obj_id_seq(id):
    '''
        根据唯一ID解析出序列号
    '''
    arr = id.split('_')
    return int(arr[1]) & 0x3FF

def get_obj_id_timestamp(id):
    '''
        根据唯一ID解析出时间戳
    '''
    arr = id.split('_')
    return (int(arr[1]) >> 10) & 0xFFFFFFFF