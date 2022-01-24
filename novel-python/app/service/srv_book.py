from app.core import ResponseCode, cache, get_global
import logging

logger = logging.getLogger(__name__)

@cache.memoize(timeout=3600)
def search_book(bid, flag, keywords, start_time, value, order, page, num):
    '''
    按条件组合索引ES书籍库
    '''
    offset = page * num
    query = []
    if bid:
        query.append({ "terms": { "bid": bid }})
    if flag:
        query.append({ "terms": { "flag": flag }})
    if keywords:
        query.append({ "match": { "keywords": keywords }})
    if start_time:
        query.append({
            "range": {
                "create_time": {
                    "gte": start_time
                }
            }
        })
    if value:
        query.append({
            "script": {
                "script": f"(doc['value'].value&{value})!=0"
            }
        })
    if order:
        arr = order.split(' ')
        sort = { arr[0]: { "order": arr[1] }}
    else:
        sort = {}
    
    query = {
        "_source": {
            "excludes": [
                "keywords"
            ]
        },
        "query": {
            "function_score": {
                "query": {
                    "bool": {
                        "must": query
                    }
                },
                "functions": [ 
                    {
                        "script_score": {
                            "script": {
                                "source": "doc['weight'].value * 0.01"
                            }
                        }
                    }
                ],
                "boost_mode": "sum"
            }
        }
    }

    dsl = {
        "from": offset,
        "size": num,
        "sort": sort
    }
    dsl.update(query)
    resp = get_global('es').search(index='book_pool', body=dsl)
    hits = resp.get('hits', {}).get('hits', [])
    results = [x['_source'] for x in hits]
    return ResponseCode.Success, results