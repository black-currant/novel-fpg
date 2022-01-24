package server

import (
	"encoding/json"
	"io/ioutil"
	"novel-go/global"
	"novel-go/model/request"
	"novel-go/model/response"
	"novel-go/utils"
	"reflect"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type ServerApi struct {
}

// 将请求参数action字段反射为接口方法动态执行
func (s *ServerApi) ReflectAction(c *gin.Context) {
	lang := c.Request.Header.Get("Accept-Language")
	lang = strings.ReplaceAll(lang, "_", "-")
	if lang != "en-US" {
		lang = "zh-CN"
	}
	c.Request.Header.Set("Accept-Language", lang)
	var req *request.Request
	body, _ := ioutil.ReadAll(c.Request.Body)
	if err := json.Unmarshal(body, &req); err != nil {
		global.FPG_LOG.Error("参数校验不通过!", zap.Error(err), zap.String("body", string(body)))
		response.Failed(response.InvalidParameter, c)
		return
	}
	if len(req.Action) == 0 || nil == req.Data {
		global.FPG_LOG.Error("参数字段不全!", zap.String("body", string(body)))
		response.Failed(response.InvalidParameter, c)
		return
	}
	global.FPG_LOG.Info("request", zap.String("body", string(body)))
	reflectValue := reflect.ValueOf(&apiService)
	// action字段转为驼峰写法函数名称
	methodName := strings.Replace(req.Action, "_", " ", -1)
	methodName = strings.Title(methodName)
	methodName = strings.Replace(methodName, " ", "", -1)
	method := reflectValue.MethodByName(methodName)
	if !method.IsValid() {
		global.FPG_LOG.Error("接口参数无效!", zap.String("body", string(body)))
		response.Failed(response.InvalidParameter, c)
		return
	}

	filterMap := map[string]bool{
		"sys_config": true,
		"login":      true,
		"auth":       true,
	}
	if _, ok := filterMap[req.Action]; !ok {
		// 校验签名，并获取用户ID
		token := c.Request.Header.Get("Access-Token")
		if len(token) == 0 {
			response.Failed(response.TokenMissing, c)
			return
		}
		jwtClaims, err := utils.ParseToken(token, global.FPG_CONFIG.Jwt.Key)
		if nil != err {
			global.FPG_LOG.Error("签名错误!", zap.Error(err))
			response.Failed(response.TokenError, c)
			return
		}
		if jwtClaims.Exp < time.Now().Unix() {
			response.Failed(response.TokenExpired, c)
			return
		}
		req.UserID = jwtClaims.Aid
	}

	req.Context = c
	reqJson, _ := json.Marshal(req)
	global.FPG_LOG.Info("execute", zap.ByteString("body", reqJson))
	params := []reflect.Value{reflect.ValueOf(req)}
	result := method.Call(params)
	code := int(result[0].Int())
	ret := result[1].Interface()
	res := response.Result(code, ret, c)
	resJson, _ := json.Marshal(res)
	global.FPG_LOG.Info("response", zap.ByteString("body", resJson))
}

// 上报埋点日志
func (s *ServerApi) Report(c *gin.Context) {
	body, _ := ioutil.ReadAll(c.Request.Body)
	global.FPG_LOG.Info("request", zap.String("body", string(body)))
	response.Result(response.Success, nil, c)
}
