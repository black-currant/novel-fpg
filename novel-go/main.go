package main

import (
	"net/http"
	"novel-go/global"
	"novel-go/initialize"
	"time"
)

func init() {
	global.FPG_VP = initialize.Viper()        // 初始化配置
	global.FPG_LOG = initialize.Zap()         // 初始化日志
	global.FPG_I18N = initialize.I18n()       // 初始化国际化
	global.FPG_DB = initialize.Gorm()         // 初始化数据库连接
	global.FPG_ELASTIC = initialize.Elastic() // 初始化ES连接
	global.FPG_REIDS = initialize.Redis()     // 初始化Redis连接
	global.FPG_QUEST = initialize.LoadQuest() // 初始化任务模板
}

func main() {
	// 程序结束前关闭数据链接
	if global.FPG_DB != nil {
		db, _ := global.FPG_DB.DB()
		defer db.Close()
	}
	if global.FPG_REIDS != nil {
		defer global.FPG_REIDS.Close()
	}
	Router := initialize.Routers()
	s := &http.Server{
		Addr:           ":8000",
		Handler:        Router,
		ReadTimeout:    30 * time.Second,
		WriteTimeout:   30 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	s.ListenAndServe()
}
