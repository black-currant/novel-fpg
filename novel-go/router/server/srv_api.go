package server

import (
	"novel-go/api"

	"github.com/gin-gonic/gin"
)

type ApiRouter struct {
}

func (s *ApiRouter) InitApiRouter(Router *gin.RouterGroup) {
	var apiRouterApi = api.ApiGroupApp.ServerApiGroup.ServerApi
	{
		Router.POST("/", apiRouterApi.ReflectAction)
		Router.POST("/report", apiRouterApi.Report)
	}
}
