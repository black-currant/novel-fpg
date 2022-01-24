package initialize

import (
	"novel-go/router"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// 初始化总路由
func Routers() *gin.Engine {
	var Router = gin.Default()

	// 注册跨域中间件
	Router.Use(cors.New(cors.Config{
		AllowMethods:     []string{"*"},
		AllowHeaders:     []string{"*"},
		AllowOrigins:     []string{"*"},
		AllowCredentials: true,
		MaxAge:           time.Hour,
	}))

	//获取路由组实例
	serverRouter := router.RouterGroupApp.Server
	PrivateGroup := Router.Group("api/v1.0")
	{
		serverRouter.InitApiRouter(PrivateGroup)
	}
	return Router
}
