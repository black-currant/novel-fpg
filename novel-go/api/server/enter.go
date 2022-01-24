package server

import "novel-go/service"

type ApiGroup struct {
	ServerApi
}

var apiService = service.ServiceGroupApp.ServerServiceGroup.ApiService
