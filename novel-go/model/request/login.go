package request

type Login struct {
	Username   string `json:"username"`
	Password   string `json:"password"`
	DeviceID   string `json:"deviceid"`
	OS         string `json:"os"`
	OSVersion  string `json:"os_version"`
	DeviceMode string `json:"device_mode"`
	AppVersion string `json:"app_version"`
	Country    string `json:"country"`
}
