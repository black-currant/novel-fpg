package request

type SetFavorites struct {
	Bids   []int `json:"bids"`
	Status int   `json:"status"`
}
