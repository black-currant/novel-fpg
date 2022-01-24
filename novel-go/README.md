## 1、开发环境

+ Go 版本

  - Go 1.17.4

+ Web框架

  - Gin

+ ORM库

  - gorm.io/gorm + MySQL

+ 缓存库

  - github.com/go-redis/redis/v8

+ 搜索库

  - github.com/elastic/go-elasticsearch/v7 v7.16.0

## 2、基础环境安装与运行

```
cd novel-go
go get
go run main.go
```

## 3、配置文件

+ 系统配置

  - config/config.yaml

+ vscode启动配置

```
{
    "name": "Launch Package",
    "type": "go",
    "request": "launch",
    "mode": "auto",
    "program": "${workspaceRoot}/main.go",
    "env": {},
    "args": []
}
```

## 4、测试接口

```
curl -X POST -d {\"action\":\"sys_config\",\"data\":{}} -H "Accept-Language: zh-CN" -H "Content-Type: application/json" http://localhost:8000/api/v1.0/
```
```
{
    "code": 0,
    "data": [],
    "message": "成功"
}
```