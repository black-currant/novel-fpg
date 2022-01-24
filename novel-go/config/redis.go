package config

type Redis struct {
	Url      string `mapstructure:"url" yaml:"url"`
	Password string `mapstructure:"password" yaml:"password"`
	DB       int    `mapstructure:"db" yaml:"db"`
}
