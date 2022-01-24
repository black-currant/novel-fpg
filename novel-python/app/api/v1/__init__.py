from flask import Blueprint

v10 = Blueprint("v1.0", __name__, url_prefix='/api/v1.0')

from . import server
from . import report