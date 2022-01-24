package response

import "novel-go/model/server"

type Login struct {
	server.UsrAccount
	Register int    `json:"register"`
	Token    string `json:"token"`
}
