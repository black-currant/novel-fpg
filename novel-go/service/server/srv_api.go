package server

import (
	"encoding/json"
	"fmt"
	"novel-go/global"
	"novel-go/middleware"
	"novel-go/model/request"
	"novel-go/model/response"
	"novel-go/model/server"
	"novel-go/utils"
	"strconv"
	"strings"
	"time"

	"github.com/go-gota/gota/dataframe"
	"github.com/go-gota/gota/series"
	"github.com/jinzhu/copier"
	"github.com/mitchellh/mapstructure"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type ApiService struct {
}

// 账号密码登陆
func (apiService *ApiService) Login(req *request.Request) (code int, data interface{}) {
	jsonData, _ := json.Marshal(req.Data)
	var loginReq request.Login
	err := json.Unmarshal(jsonData, &loginReq)
	if nil != err {
		return response.InvalidParameter, nil
	}
	if len(loginReq.Username) == 0 || len(loginReq.Password) == 0 {
		return response.InvalidParameter, nil
	}
	if nil == global.FPG_DB {
		global.FPG_LOG.Error("db not init")
		return response.InternalServerError, nil
	}
	register := 0
	var user server.UsrAccount
	err = global.FPG_DB.Where("account = ?", loginReq.Username).First(&user).Error
	if nil != err {
		if err == gorm.ErrRecordNotFound {
			register = 1
			user.Account = loginReq.Username
			user.Password = utils.EncodePassword(loginReq.Password, utils.GenSalt(8), 150000)
			user.Deviceid = loginReq.DeviceID
			err = global.FPG_DB.Create(&user).Error
			if nil != err {
				global.FPG_LOG.Error("create user", zap.Error(err))
				return response.InternalServerError, nil
			}
		} else {
			return response.UserNotFound, nil
		}
	} else {
		ok, err := utils.VerifyPassword(loginReq.Password, user.Password)
		if nil != err {
			global.FPG_LOG.Error("verify password error", zap.Error(err))
			return response.InternalServerError, nil
		}
		if !ok {
			return response.PasswordError, nil
		}
	}

	user.OS = loginReq.OS
	user.OSVersion = loginReq.OSVersion
	user.DeviceMode = loginReq.DeviceMode
	user.AppVersion = loginReq.AppVersion
	user.Country = loginReq.Country
	return apiService.LoginSuccess(&user, register, req.Context)
}

// 第三方平台授权登陆
func (apiService *ApiService) Auth(req *request.Request) (code int, data interface{}) {
	// 暂未实现
	return response.Success, nil
}

// 修改用户信息
func (apiService *ApiService) ModInfo(req *request.Request) (code int, data interface{}) {
	var user server.UsrAccount
	err := global.FPG_DB.Where("id = ?", req.UserID).First(&user).Error
	if nil != err {
		return response.UserNotFound, nil
	}

	// 不允许更新的用户字段
	filterMap := map[string]bool{
		"id":       true,
		"account":  true,
		"password": true,
		"vip":      true,
		"viptime":  true,
		"score":    true,
		"logtime":  true,
		"status":   true,
	}

	modReq, ok := req.Data.(map[string]interface{})
	if !ok {
		return response.InvalidParameter, nil
	}
	for key := range modReq {
		if _, ok := filterMap[key]; ok {
			return response.InvalidParameter, nil
		}
	}

	var updUser server.UsrAccount
	if err := mapstructure.Decode(modReq, &updUser); err != nil {
		return response.InvalidParameter, nil
	}

	global.FPG_DB.Model(&user).Updates(updUser)

	return response.Success, nil
}

// 获取子账号列表
func (apiService *ApiService) BindList(req *request.Request) (code int, data interface{}) {
	// 暂未实现
	return response.Success, nil
}

// 获取用户信息
func (apiService *ApiService) GetInfo(req *request.Request) (code int, data interface{}) {
	var user server.UsrAccount
	err := global.FPG_DB.Where("id = ?", req.UserID).First(&user).Error
	if nil != err {
		return response.UserNotFound, nil
	}

	return response.Success, user
}

// 获取书籍列表
func (apiService *ApiService) BookList(req *request.Request) (code int, data interface{}) {
	return middleware.CacheMemoize(SearchBook, 3600, req)
}

// 获取获取书架
func (apiService *ApiService) GetFavorites(req *request.Request) (code int, data interface{}) {
	books := make([]server.ResBook, 0)
	sql := fmt.Sprintf("SELECT b.* FROM usr_favorites a JOIN res_book b ON a.bid = b.id WHERE a.uid = %d AND a.`status` = 1", req.UserID)
	err := global.FPG_DB.Raw(sql).Scan(&books).Error
	if nil != err {
		global.FPG_LOG.Error("execute sql error", zap.Error(err))
		return response.InternalServerError, nil
	}

	return response.Success, books
}

// 收藏书籍
func (apiService *ApiService) SetFavorites(req *request.Request) (code int, data interface{}) {
	jsonData, _ := json.Marshal(req.Data)
	var setFavoritesReq request.SetFavorites
	err := json.Unmarshal(jsonData, &setFavoritesReq)
	if nil != err {
		return response.InvalidParameter, nil
	}
	tx := global.FPG_DB.Begin()
	for _, v := range setFavoritesReq.Bids {
		sql := fmt.Sprintf("INSERT INTO usr_favorites(uid, bid, `status`) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE `status` = %d, UpdateTime = CURRENT_TIMESTAMP", req.UserID, v, setFavoritesReq.Status, setFavoritesReq.Status)
		err := tx.Exec(sql).Error
		if nil != err {
			global.FPG_LOG.Error("execute sql error", zap.Error(err))
			tx.Rollback()
			return response.InternalServerError, nil
		}
	}
	tx.Commit()

	return response.Success, nil
}

// 获取热搜关键词
func (apiService *ApiService) HotKeywords(req *request.Request) (code int, data interface{}) {
	return middleware.CacheMemoize(GetHotKeywords, 3600, req)
}

// 获取书籍类目
func (apiService *ApiService) GetCategories(req *request.Request) (code int, data interface{}) {
	return middleware.CacheMemoize(GetBookCategories, 3600, req)
}

// 获取任务列表
func (apiService *ApiService) QuestList(req *request.Request) (code int, data interface{}) {
	quests := make([]server.UsrQuest, 0)
	err := global.FPG_DB.Where("uid = ?", req.UserID).Find(&quests).Error
	if nil != err {
		return response.InternalServerError, nil
	}
	today := time.Now().Format("%Y-%m-%d")

	questMap := make(map[string]server.UsrQuest, 0)
	for _, v := range quests {
		questMap[v.Tid] = v
	}
	results := make([]map[string]interface{}, 0)
	tx := global.FPG_DB.Begin()
	for _, v := range global.FPG_QUEST.Maps() {
		questDoing := make(map[string]interface{}, 0)
		copier.Copy(&questDoing, &v)
		paramsArr := strings.Split(v["Param"].(string), "|")
		questObj, ok := questMap[v["Task ID"].(string)]
		if ok {
			if questDoing["Task Type"] == "daily" { // 每日任务
				if questObj.UpdateTime.Format("%Y-%m-%d") != today {
					questObj.Status = 0
					questObj.UpdateTime = time.Now()
				}
			} else if questDoing["Task Type"] == "loop" { // 日环任务
				if questObj.UpdateTime.Format("%Y-%m-%d") != today {
					if questObj.Progress+1 >= len(paramsArr) || (time.Since(questObj.UpdateTime).Hours()/24) > 1 {
						questObj.Progress = 0
					} else {
						questObj.Progress += 1
					}
					questObj.Status = 0
					questObj.UpdateTime = time.Now()
				}
			} else if questDoing["Task Type"] == "weekly" { // 每周任务
				if utils.WeekByDate(time.Now()) > utils.WeekByDate(questObj.UpdateTime) {
					questObj.Status = 0
					questObj.Progress = 0
					questObj.UpdateTime = time.Now()
				}
			}
			questDoing["status"] = questObj.Status
			questDoing["progress"] = questObj.Progress
			tx.Model(&questObj).Updates(server.UsrQuest{
				Status:     questObj.Status,
				Progress:   questObj.Progress,
				UpdateTime: questObj.UpdateTime,
			})
		} else {
			questDoing["status"] = 0
			questDoing["progress"] = 0
		}
		tx.Commit()

		results = append(results, questDoing)
	}

	return response.Success, results
}

// 领取任务奖励
func (apiService *ApiService) QuestReward(req *request.Request) (code int, data interface{}) {
	tid, ok := req.Data.(map[string]interface{})["tid"].(string)
	if !ok || len(tid) == 0 {
		return response.InvalidParameter, nil
	}

	var user server.UsrAccount
	err := global.FPG_DB.Where("id = ?", req.UserID).First(&user).Error
	if nil != err {
		return response.UserNotFound, nil
	}

	return apiService.ReceiveQuestReward(&user, tid)
}

// 上报阅读记录
func (apiService *ApiService) ReadLog(req *request.Request) (code int, data interface{}) {
	jsonData, _ := json.Marshal(req.Data)
	var usrReadLogReq server.UsrReadLog
	err := json.Unmarshal(jsonData, &usrReadLogReq)
	if nil != err {
		return response.InvalidParameter, nil
	}
	if usrReadLogReq.Duration <= 0 {
		return response.InvalidParameter, nil
	}
	var user server.UsrAccount
	err = global.FPG_DB.Where("id = ?", req.UserID).First(&user).Error
	if nil != err {
		return response.UserNotFound, nil
	}

	tid := "task.read.duration"
	questTpl := global.FPG_QUEST.Filter(
		dataframe.F{
			Colname:    "Task ID",
			Comparator: series.Eq,
			Comparando: tid,
		},
	)
	params := questTpl.Select("Param").Records()
	paramsArr := strings.Split(params[1][0], "|")
	score := questTpl.Select("Virtual Currency").Records()
	scoreArr := strings.Split(score[1][0], "|")

	user.Duration += uint(usrReadLogReq.Duration)
	var quest server.UsrQuest
	questErr := global.FPG_DB.Where("uid = ? AND tid = ?", req.UserID, tid).First(&quest).Error
	progress := -1
	if nil != questErr {
		progress = quest.Progress
	}
	tx := global.FPG_DB.Begin()
	for i := progress + 1; i < len(paramsArr); i++ {
		v, _ := strconv.Atoi(paramsArr[i])
		if int(user.Duration) >= v {
			score, _ := strconv.Atoi(scoreArr[i])
			score_before := user.Score
			user.Score = score_before + uint(score)
			usrScore := server.UsrScore{
				Uid:         req.UserID,
				Score:       score,
				ScoreBefore: score_before,
				ScoreAfter:  user.Score,
				SourceId:    tid,
				Remark:      "阅读奖励",
			}
			err = global.FPG_DB.Create(&usrScore).Error
			if nil != err {
				global.FPG_LOG.Error("create user score", zap.Error(err))
				tx.Callback()
				return response.InternalServerError, nil
			}
			if nil != questErr {
				quest = server.UsrQuest{
					Uid:      uint(req.UserID),
					Tid:      tid,
					Status:   1,
					Progress: i,
				}
				err = global.FPG_DB.Create(&quest).Error
				if nil != err {
					global.FPG_LOG.Error("create user quest", zap.Error(err))
					tx.Callback()
					return response.InternalServerError, nil
				}
			} else {
				tx.Model(&quest).Updates(server.UsrQuest{
					Status:     1,
					Progress:   i,
					UpdateTime: time.Now(),
				})
			}
		}
	}
	err = global.FPG_DB.Create(&usrReadLogReq).Error
	if nil != err {
		global.FPG_LOG.Error("create user read log", zap.Error(err))
		tx.Callback()
		return response.InternalServerError, nil
	}
	tx.Model(&user).Updates(server.UsrAccount{
		Score:    user.Score,
		Duration: user.Duration,
	})
	tx.Commit()

	results := make(map[string]uint)
	results["score"] = user.Score
	results["duration"] = user.Duration

	return response.Success, results
}

// 检查消息
func (apiService *ApiService) CheckMessage(req *request.Request) (code int, data interface{}) {
	// 暂未实现
	return response.Success, nil
}

// 获取书币流水
func (apiService *ApiService) ScoreFlow(req *request.Request) (code int, data interface{}) {
	page, _ := req.Data.(map[string]interface{})["num"].(float64)
	num, _ := req.Data.(map[string]interface{})["num"].(float64)
	if num == 0 {
		num = 30
	}
	usrScores := make([]server.UsrScore, 0)
	err := global.FPG_DB.Limit(int(num)).Offset(int(page*num)).Find(&usrScores).Where("uid = ?", req.UserID).Error
	if nil != err {
		return response.InternalServerError, nil
	}

	return response.Success, usrScores
}

// 购买章节
func (apiService *ApiService) BuyChapter(req *request.Request) (code int, data interface{}) {
	buyChapterReq, ok := req.Data.(request.BuyChapter)
	if !ok {
		return response.InvalidParameter, nil
	}
	var user server.UsrAccount
	err := global.FPG_DB.Where("id = ?", req.UserID).First(&user).Error
	if nil != err {
		return response.UserNotFound, nil
	}

	if buyChapterReq.Score > 0 {
		tx := global.FPG_DB.Begin()
		score := -buyChapterReq.Score
		score_before := user.Score
		user.Score = score_before + uint(score)
		tx.Model(&user).Update("score", user.Score)
		usrScore := server.UsrScore{
			Uid:         req.UserID,
			Score:       score,
			ScoreBefore: score_before,
			ScoreAfter:  user.Score,
			SourceId:    strconv.Itoa(buyChapterReq.Cid),
			Remark:      "购买章节",
		}
		err = global.FPG_DB.Create(&usrScore).Error
		if nil != err {
			global.FPG_LOG.Error("create user score", zap.Error(err))
			tx.Callback()
			return response.InternalServerError, nil
		}
		usrChapter := server.UsrChapter{
			Uid: req.UserID,
			Bid: buyChapterReq.Bid,
			Cid: buyChapterReq.Cid,
		}
		err = global.FPG_DB.Create(&usrChapter).Error
		if nil != err {
			global.FPG_LOG.Error("create user chapter", zap.Error(err))
			tx.Callback()
			return response.InternalServerError, nil
		}
		tx.Commit()
	}

	results := make(map[string]uint)
	results["score"] = user.Score

	return response.Success, results
}

// 获取用户已购买章节
func (apiService *ApiService) UserChapter(req *request.Request) (code int, data interface{}) {
	bid, ok := req.Data.(map[string]interface{})["bid"].(float64)
	if !ok {
		return response.InvalidParameter, nil
	}
	chapters := make([]server.UsrChapter, 0)
	err := global.FPG_DB.Where("uid = ? AND bid = ?", req.UserID, int(bid)).Find(&chapters).Error
	if nil != err {
		global.FPG_LOG.Error("execute sql error", zap.Error(err))
		return response.InternalServerError, nil
	}

	return response.Success, chapters
}

// 获取系统设置
func (apiService *ApiService) SysConfig(req *request.Request) (code int, data interface{}) {
	settings := make([]server.SysSetting, 0)
	err := global.FPG_DB.Where("source = 'server'").Find(&settings).Error
	if nil != err {
		global.FPG_LOG.Error("execute sql error", zap.Error(err))
		return response.InternalServerError, nil
	}

	return response.Success, settings
}
