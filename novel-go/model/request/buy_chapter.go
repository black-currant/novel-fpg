package request

type BuyChapter struct {
	Bid   int `json:"bid"`
	Cid   int `json:"cid"`
	Score int `json:"score"`
}
