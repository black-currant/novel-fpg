package server

import (
	"time"
)

type UsrAccount struct {
	ID         uint      `json:"id" gorm:"primarykey"` // 主键ID
	Account    string    `json:"account"`
	Password   string    `json:"-"`
	Nickname   string    `json:"nickname"`
	Gender     string    `json:"gender"`
	Phone      string    `json:"phone"`
	Email      string    `json:"email"`
	Photourl   string    `json:"photourl"`
	Deviceid   string    `json:"deviceid"`
	OS         string    `json:"os"`
	OSVersion  string    `json:"os_version"`
	DeviceMode string    `json:"device_mode"`
	AppVersion string    `json:"app_version"`
	Country    string    `json:"country"`
	Provider   string    `json:"provider"`
	Pid        string    `json:"pid"`
	Vip        bool      `json:"vip"`
	Viptime    time.Time `json:"viptime"`
	Score      uint      `json:"score"`
	Duration   uint      `json:"duration"`
	Preference uint      `json:"preference"`
	MainID     uint      `json:"main_id"`
	Logip      string    `json:"logip"`
	Logtime    time.Time `json:"logtime"`
	Status     int       `json:"status"`
}

func (u *UsrAccount) TableName() string {
	return "usr_account"
}
