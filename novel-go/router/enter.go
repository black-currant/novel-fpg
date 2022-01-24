package router

import "novel-go/router/server"

type RouterGroup struct {
	Server server.RouterGroup
}

var RouterGroupApp = new(RouterGroup)
