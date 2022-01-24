package initialize

import (
	"github.com/BurntSushi/toml"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"golang.org/x/text/language"
)

func I18n() *i18n.Bundle {
	bundle := i18n.NewBundle(language.Chinese)
	bundle.RegisterUnmarshalFunc("toml", toml.Unmarshal)
	bundle.LoadMessageFile("message/zh-CN.toml")
	bundle.LoadMessageFile("message/en-US.toml")
	return bundle
}
