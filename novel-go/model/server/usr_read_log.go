package server

import "time"

type UsrReadLog struct {
	ID         uint      `json:"id" gorm:"primarykey"` // 主键ID
	Uid        int       `json:"uid"`
	Bid        int       `json:"bid"`
	Duration   int       `json:"duration"`
	CreateTime time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time;default:null"`
}

func (c *UsrReadLog) TableName() string {
	return "usr_read_log"
}
