# novel-python

## 1、开发环境

+ Python 版本

  - Python 3.6.7

+ Web框架

  - Flask

+ ORM库

  - Flask-SQLAlchemy + PyMySQL

+ 缓存库

  - Flask-Caching + redis

+ 搜索库

  - elasticsearch 7.12

## 2、基础环境安装与运行

+ Windows系统

```
cd novel-python
python3.6 -m venv venv
venv/Scripts/activate
easy_install -U pip
pip3 install -r requirements.txt
python3 run.py runserver
```

+ Linux系统

```
cd novel-python
python3.6 -m venv venv
chmod +x venv/bin/*
venv/bin/activate
venv/bin/easy_install -U pip
venv/bin/pip3 install -r requirements.txt
venv/bin/python3 run.py runserver
```

## 3、配置文件

+ 系统配置

  - config/config.yaml

+ vscode启动配置

```
{
    "name": "Python: Flask",
    "type": "python",
    "request": "launch",
    "stopOnEntry": false,
    "module": "flask",
    "env": {
        "FLASK_APP": "./run.py",
        "FLASK_RUN_HOST": "0.0.0.0",
        "FLASK_RUN_PORT": "5000",
        "FLASK_DEBUG": "1"
    },
    "args": [
        "run",
        "--no-debugger",
        "--no-reload"
    ]
}
```

## 4、测试接口

```
curl -X POST -d {\"action\":\"sys_config\",\"data\":{}} -H "Accept-Language: zh-CN" -H "Content-Type: application/json" http://localhost:5000/api/v1.0/
```
```
{
    "code": 0,
    "data": [],
    "message": "成功"
}
```