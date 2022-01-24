package request

import "github.com/gin-gonic/gin"

type Request struct {
	Action  string       `json:"action"`
	Data    interface{}  `json:"data"`
	Context *gin.Context `json:"-"`
	UserID  int          `json:"aid"`
}
