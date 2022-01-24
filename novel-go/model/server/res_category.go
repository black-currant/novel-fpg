package server

type ResCategory struct {
	ID       uint   `json:"id" gorm:"primarykey"` // 主键ID
	Value    int    `json:"value"`
	Category string `json:"category"`
	Image    string `json:"image"`
	BookCnt  int    `mapstructure:"book_cnt" json:"book_cnt" gorm:"book_cnt"`
	Code     int    `json:"code"`
}

func (c *ResCategory) TableName() string {
	return "res_category"
}
