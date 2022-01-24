package server

import "time"

type UsrQuest struct {
	ID         uint      `json:"id" gorm:"primarykey"` // 主键ID
	Uid        uint      `json:"uid"`
	Tid        string    `json:"tid"`
	Status     int       `json:"status"`
	Progress   int       `json:"progress"`
	CreateTime time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time;default:null"`
	UpdateTime time.Time `mapstructure:"update_time"  json:"update_time" gorm:"update_time;default:null"`
}

func (c *UsrQuest) TableName() string {
	return "usr_quest"
}
