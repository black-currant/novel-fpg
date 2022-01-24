package server

import "time"

type SysSetting struct {
	ID         uint      `json:"id" gorm:"primarykey"` // 主键ID
	Source     string    `json:"source"`
	Name       string    `json:"name"`
	Option     string    `json:"option"`
	Status     int       `json:"status"`
	CreateTime time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time"`
	UpdateTime time.Time `mapstructure:"update_time" json:"update_time" gorm:"update_time"`
}

func (c *SysSetting) TableName() string {
	return "sys_setting"
}
