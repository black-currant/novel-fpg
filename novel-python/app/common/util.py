import datetime
import logging
import jwt

def get_clientip(request):
    if request.headers.getlist("X-Forwarded-For"):
        client_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        client_ip = request.remote_addr

    return client_ip

def get_token(aid, src, key, exp):
    token_dict = {
        'aid': aid, 
        'src': src, 
        'iat': int(datetime.datetime.utcnow().timestamp()),
        'exp': int((datetime.datetime.utcnow() + datetime.timedelta(seconds=exp)).timestamp())
    }
    jwt_token = jwt.encode(token_dict, key, algorithm="HS256")
    return jwt_token

def parse_token(token, key):
    try:
        token_dict = jwt.decode(token, key, algorithms=['HS256'])
        return token_dict
    except Exception as e:
        return {}