package api

import "novel-go/api/server"

type ApiGroup struct {
	ServerApiGroup server.ApiGroup
}

var ApiGroupApp = new(ApiGroup)
