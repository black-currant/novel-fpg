package service

import "novel-go/service/server"

type ServiceGroup struct {
	ServerServiceGroup server.ServiceGroup
}

var ServiceGroupApp = new(ServiceGroup)
