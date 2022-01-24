package middleware

import (
	"context"
	"encoding/json"
	"fmt"
	"novel-go/global"
	"novel-go/model/request"
	"novel-go/model/response"
	"time"

	"novel-go/utils"

	"github.com/go-redis/redis/v8"
	"go.uber.org/zap"
)

type ApiServiceHandler func(req *request.Request) (code int, data interface{})

// 缓存接口数据
func CacheMemoize(f ApiServiceHandler, timeout int64, req *request.Request) (code int, data interface{}) {
	jsonData, _ := json.Marshal(req.Data)
	key := fmt.Sprintf("%s_%s", req.Action, utils.GetMd5(jsonData))
	var ctx = context.Background()
	val, err := global.FPG_REIDS.Get(ctx, key).Result()
	if err != nil {
		if err != redis.Nil {
			global.FPG_LOG.Error("get cache error", zap.Error(err))
		}
	} else {
		var res response.Response
		err = json.Unmarshal([]byte(val), &res)
		if err != nil {
			global.FPG_LOG.Error("json parse error", zap.Error(err))
		} else {
			return res.Code, res.Data
		}
	}

	var res response.Response
	res.Code, res.Data = f(req)
	jsonData, _ = json.Marshal(res)
	if res.Code == response.Success {
		err = global.FPG_REIDS.Set(ctx, key, string(jsonData), time.Second*time.Duration(timeout)).Err()
		if err != nil {
			global.FPG_LOG.Error("set cache error", zap.Error(err))
		}
	}
	return res.Code, res.Data
}
