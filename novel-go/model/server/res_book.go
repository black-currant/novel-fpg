package server

import (
	"encoding/json"
	"errors"
	"time"

	"github.com/mitchellh/mapstructure"
)

type ResBook struct {
	ID             uint      `json:"id" gorm:"primarykey"` // 主键ID
	Title          string    `json:"title"`
	Image          string    `json:"image"`
	Category       string    `json:"category"`
	Author         string    `json:"author"`
	ChapterCnt     int       `mapstructure:"chapter_cnt" json:"chapter_cnt" gorm:"chapter_cnt"`
	Intro          string    `json:"intro"`
	Flag           int       `json:"flag"`
	Free           int       `json:"free"`
	Value          int       `json:"value"`
	FreeChapterCnt int       `mapstructure:"free_chapter_cnt" json:"free_chapter_cnt" gorm:"free_chapter_cnt"`
	ChapterCost    int       `mapstructure:"chapter_cost" json:"chapter_cost" gorm:"chapter_cost"`
	Tags           string    `json:"tags"`
	RecentChapter  string    `mapstructure:"recent_chapter" json:"recent_chapter" gorm:"recent_chapter"`
	CatalogLink    string    `mapstructure:"catalog_link" json:"catalog_link" gorm:"catalog_link"`
	WordsCnt       int       `mapstructure:"words_cnt" json:"words_cnt" gorm:"words_cnt"`
	Status         int       `json:"status"`
	CreateTime     time.Time `mapstructure:"create_time" json:"create_time" gorm:"create_time"`
	UpdateTime     time.Time `mapstructure:"update_time" json:"update_time" gorm:"create_time"`
}

func (b *ResBook) TableName() string {
	return "res_book"
}

type AliasBook ResBook

type TempBook struct {
	AliasBook
	CreateTime string `mapstructure:"create_time" json:"create_time"`
	UpdateTime string `mapstructure:"update_time" json:"update_time"`
}

func (b *ResBook) UnmarshalJSON(data []byte) error {
	// 反序列化的时候处理时间格式不一致问题
	if b == nil {
		return errors.New("json.RawMessage: UnmarshalJSON on nil pointer")
	}
	tmpBook := TempBook{
		AliasBook: (AliasBook)(*b),
	}

	if err := json.Unmarshal(data, &tmpBook); err != nil {
		return err
	}
	l, _ := time.LoadLocation("Asia/Shanghai")
	b.CreateTime, _ = time.ParseInLocation("2006-01-02T15:04:05", tmpBook.CreateTime, l)
	b.UpdateTime, _ = time.ParseInLocation("2006-01-02T15:04:05", tmpBook.UpdateTime, l)
	return nil
}

func (b *ResBook) UndecodeMap(o interface{}) error {
	m := o.(map[string]interface{})
	createTime := m["create_time"].(string)
	updateTime := m["update_time"].(string)
	delete(m, "create_time")
	delete(m, "update_time")
	if err := mapstructure.Decode(m, b); err != nil {
		return err
	}
	l, _ := time.LoadLocation("Asia/Shanghai")
	b.CreateTime, _ = time.ParseInLocation("2006-01-02T15:04:05", createTime, l)
	b.UpdateTime, _ = time.ParseInLocation("2006-01-02T15:04:05", updateTime, l)
	return nil
}
