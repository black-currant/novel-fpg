package request

type QueryBook struct {
	Bid       string `json:"bid"`
	Flag      int    `json:"flag"`
	Keywords  string `json:"keywords"`
	StartTime string `json:"start_time"`
	Value     int    `json:"value"`
	Order     string `json:"order"`
	Page      int    `json:"page"`
	Num       int    `json:"num"`
}
