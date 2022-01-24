package server

import "time"

type UsrChapter struct {
	ID         uint      `json:"id" gorm:"primarykey"` // 主键ID
	Uid        int       `json:"uid"`
	Bid        int       `json:"bid"`
	Cid        int       `json:"cid"`
	CreateTime time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time;default:null"`
}

func (c *UsrChapter) TableName() string {
	return "usr_chapter"
}
