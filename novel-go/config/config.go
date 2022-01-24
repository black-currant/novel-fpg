package config

type Server struct {
	Jwt     Jwt     `yaml:"jwt"`
	Mysql   Mysql   `yaml:"mysql"`
	Elastic Elastic `yaml:"elastic"`
	Redis   Redis   `yaml:"redis"`
	Zap     Zap     `yaml:"zap"`
}
