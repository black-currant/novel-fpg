from app.core import ResponseCode, db, cache, get_global, make_response
from . import v10

@v10.route('/report', methods=["POST"], endpoint="report")
@make_response
def report(data, aid):
    """
    上报埋点日志
    """
    return ResponseCode.Success, {}