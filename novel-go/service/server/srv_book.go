package server

import (
	"context"
	"encoding/json"
	"novel-go/global"
	"novel-go/model/request"
	"novel-go/model/response"
	"novel-go/model/server"
	"strconv"
	"strings"

	"go.uber.org/zap"
)

func SearchBook(req *request.Request) (code int, data interface{}) {
	jsonData, _ := json.Marshal(req.Data)
	var queryBook request.QueryBook
	err := json.Unmarshal(jsonData, &queryBook)
	if nil != err {
		return response.InvalidParameter, nil
	}

	if queryBook.Num == 0 {
		queryBook.Num = 30
	}
	offset := queryBook.Page * queryBook.Num
	boolQuery := make([]string, 0)
	if len(queryBook.Bid) > 0 {
		boolQuery = append(boolQuery, `{ "terms": { "bid": "`+queryBook.Bid+`" }}`)
	}
	if queryBook.Flag > 0 {
		boolQuery = append(boolQuery, `{ "terms": { "flag": `+strconv.Itoa(queryBook.Flag)+` }}`)
	}
	if len(queryBook.Keywords) > 0 {
		boolQuery = append(boolQuery, `{ "match": { "keywords": "`+queryBook.Keywords+`" }}`)
	}
	if len(queryBook.StartTime) > 0 {
		boolQuery = append(boolQuery, `{
            "range": {
                "create_time": {
                    "gte": "`+queryBook.StartTime+`"
                }
            }
        }`)
	}
	if queryBook.Value > 0 {
		boolQuery = append(boolQuery, `{
            "script": {
                "script": "(doc['value'].value&`+strconv.Itoa(queryBook.Value)+`)!=0"
            }
        }`)
	}
	query := `{
        "_source": {
            "excludes": [
                "keywords"
            ]
        },
        "query": {
            "function_score": {
                "query": {
                    "bool": {
                        "must": [` + strings.Join(boolQuery, ",") + `]
                    }
                },
                "functions": [ 
                    {
                        "script_score": {
                            "script": {
                                "source": "doc['weight'].value * 0.01"
                            }
                        }
                    }
                ],
                "boost_mode": "sum"
            }
        }
    }`
	es := global.FPG_ELASTIC
	res, err := es.Search(
		es.Search.WithContext(context.Background()),
		es.Search.WithIndex("book_pool"),
		es.Search.WithBody(strings.NewReader(query)),
		es.Search.WithTrackTotalHits(true),
		es.Search.WithPretty(),
		es.Search.WithSort(strings.Replace(queryBook.Order, " ", ":", 1)),
		es.Search.WithFrom(offset),
		es.Search.WithSize(queryBook.Num),
	)
	if nil != err {
		global.FPG_LOG.Error("search book error", zap.Error(err))
		return response.InternalServerError, nil
	}
	defer res.Body.Close()
	var r map[string]interface{}
	if err := json.NewDecoder(res.Body).Decode(&r); err != nil {
		global.FPG_LOG.Error("parsing the response body error", zap.Error(err))
		return response.InternalServerError, nil
	}
	if _, ok := r["error"]; ok {
		return response.InternalServerError, nil
	}
	results := make([]server.ResBook, 0)
	for _, hit := range r["hits"].(map[string]interface{})["hits"].([]interface{}) {
		_source := hit.(map[string]interface{})["_source"]
		resBook := &server.ResBook{}
		err := resBook.UndecodeMap(_source)
		if err != nil {
			global.FPG_LOG.Error("parsing the response body error", zap.Error(err))
		}
		results = append(results, *resBook)
	}
	return response.Success, results
}
