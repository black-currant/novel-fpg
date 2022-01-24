package config

type Jwt struct {
	Key        string `mapstructure:"key" yaml:"key"`
	ExpireTime int    `mapstructure:"expire-time" yaml:"expire-time"`
}
