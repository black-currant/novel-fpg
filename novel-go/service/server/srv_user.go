package server

import (
	"novel-go/global"
	"novel-go/model/response"
	"novel-go/model/server"
	"novel-go/utils"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-gota/gota/dataframe"
	"github.com/go-gota/gota/series"
	"github.com/jinzhu/copier"
	"go.uber.org/zap"
)

// 登陆后处理
func (apiService *ApiService) LoginSuccess(user *server.UsrAccount, register int, c *gin.Context) (code int, data interface{}) {
	if register == 1 {
		// 发放新注册用户奖励

	}
	if utils.WeekByDate(time.Now()) > utils.WeekByDate(user.Logtime) {
		// 每周阅读时长
		user.Duration = 0
	}
	user.Logip = c.ClientIP()
	user.Logtime = time.Now()
	var ret response.Login
	copier.Copy(&ret, &user)
	ret.Register = register
	ret.Token = utils.CreateToken(user.ID, "app", global.FPG_CONFIG.Jwt.Key, global.FPG_CONFIG.Jwt.ExpireTime)

	global.FPG_DB.Model(&user).Updates(server.UsrAccount{
		OS:         user.OS,
		OSVersion:  user.OSVersion,
		DeviceMode: user.DeviceMode,
		AppVersion: user.AppVersion,
		Country:    user.Country,
		Logip:      user.Logip,
		Logtime:    user.Logtime,
	})

	return response.Success, ret
}

// 领取任务奖励
func (apiService *ApiService) ReceiveQuestReward(user *server.UsrAccount, tid string) (code int, data interface{}) {
	questTpl := global.FPG_QUEST.Filter(
		dataframe.F{
			Colname:    "Task ID",
			Comparator: series.Eq,
			Comparando: tid,
		},
	)
	if nil != questTpl.Err {
		return response.ObjectNotFound, nil
	}

	questType := questTpl.Select("Task Type").Records()[1][0]
	var quest server.UsrQuest
	questErr := global.FPG_DB.Where("uid = ? AND tid = ?", user.ID, tid).First(&quest).Error
	if questType == "newbie" {
		if nil == questErr {
			return response.QuestFinished, nil
		}
	} else if questType == "daily" {
		if nil == questErr && quest.Status == 1 {
			return response.QuestFinished, nil
		}
	} else if questType == "loop" {
		if nil == questErr && quest.Status == 1 {
			return response.QuestFinished, nil
		}
	} else {
		return response.QuestTypeError, nil
	}
	tx := global.FPG_DB.Begin()
	if nil != questErr {
		quest = server.UsrQuest{
			Uid:      user.ID,
			Tid:      tid,
			Status:   1,
			Progress: 0,
		}
		err := global.FPG_DB.Create(&quest).Error
		if nil != err {
			global.FPG_LOG.Error("create user quest", zap.Error(err))
			tx.Callback()
			return response.InternalServerError, nil
		}
	} else {
		tx.Model(&quest).Updates(server.UsrQuest{
			Status:     1,
			UpdateTime: time.Now(),
		})
	}
	currency := questTpl.Select("Virtual Currency").Records()
	currencyArr := strings.Split(currency[1][0], "|")
	scoreStr := currencyArr[quest.Progress]
	score_before := user.Score
	score, _ := strconv.Atoi(scoreStr)
	user.Score = score_before + uint(score)
	remark := questTpl.Select("Locale; Title; Description").Records()
	remarkArr := strings.Split(remark[1][0], "; ")
	usrScore := server.UsrScore{
		Uid:         int(user.ID),
		Score:       score,
		ScoreBefore: score_before,
		ScoreAfter:  user.Score,
		SourceId:    tid,
		Remark:      remarkArr[1],
	}
	err := global.FPG_DB.Create(&usrScore).Error
	if nil != err {
		global.FPG_LOG.Error("create user score", zap.Error(err))
		tx.Callback()
		return response.InternalServerError, nil
	}
	tx.Model(&user).Update("score", user.Score)
	tx.Commit()

	results := make(map[string]uint)
	results["score"] = user.Score

	return response.Success, results
}
