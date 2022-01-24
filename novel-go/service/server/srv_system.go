package server

import (
	"fmt"
	"novel-go/global"
	"novel-go/model/request"
	"novel-go/model/response"
	"novel-go/model/server"

	"go.uber.org/zap"
)

// 获取热搜关键词
func GetHotKeywords(req *request.Request) (code int, data interface{}) {
	num, _ := req.Data.(map[string]interface{})["num"].(float64)
	if num == 0 {
		num = 30
	}
	keywords := make([]response.Keyword, 0)
	sql := fmt.Sprintf("SELECT keyword, COUNT(*) cnt FROM sys_keywords GROUP BY keyword ORDER BY COUNT(*) DESC LIMIT %d", num)
	err := global.FPG_DB.Raw(sql).Scan(&keywords).Error
	if nil != err {
		global.FPG_LOG.Error("execute sql error", zap.Error(err))
		return response.InternalServerError, nil
	}

	return response.Success, keywords
}

// 获取书籍类目
func GetBookCategories(req *request.Request) (code int, data interface{}) {
	categories := make([]server.ResCategory, 0)
	sql := "SELECT * FROM sys_category WHERE book_cnt > 0"
	err := global.FPG_DB.Raw(sql).Scan(&categories).Error
	if nil != err {
		global.FPG_LOG.Error("execute sql error", zap.Error(err))
		return response.InternalServerError, nil
	}

	return response.Success, categories
}
