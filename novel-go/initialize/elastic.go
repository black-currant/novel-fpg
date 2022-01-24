package initialize

import (
	"novel-go/global"

	"github.com/elastic/go-elasticsearch/v7"
)

func Elastic() *elasticsearch.Client {
	cfg := elasticsearch.Config{
		Addresses: []string{
			global.FPG_CONFIG.Elastic.Url,
		},
	}
	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		panic("init elastic err:" + err.Error())
	}
	return es
}
