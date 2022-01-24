package server

import "time"

type UsrScore struct {
	ID          uint      `json:"id" gorm:"primarykey"` // 主键ID
	Uid         int       `json:"uid"`
	Score       int       `json:"score"`
	ScoreBefore uint      `mapstructure:"score_before" json:"score_before" gorm:"score_before"`
	ScoreAfter  uint      `mapstructure:"score_after" json:"score_after" gorm:"score_after"`
	SourceId    string    `mapstructure:"source_id" json:"source_id" gorm:"source_id"`
	Remark      string    `json:"remark"`
	CreateTime  time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time;default:null"`
}

func (c *UsrScore) TableName() string {
	return "usr_score"
}
