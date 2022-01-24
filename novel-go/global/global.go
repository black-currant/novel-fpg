package global

import (
	"novel-go/config"

	"github.com/elastic/go-elasticsearch/v7"
	"github.com/go-gota/gota/dataframe"
	"github.com/go-redis/redis/v8"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"github.com/spf13/viper"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

var (
	FPG_DB      *gorm.DB
	FPG_ELASTIC *elasticsearch.Client
	FPG_REIDS   *redis.Client
	FPG_VP      *viper.Viper
	FPG_CONFIG  config.Server
	FPG_I18N    *i18n.Bundle
	FPG_LOG     *zap.Logger
	FPG_QUEST   *dataframe.DataFrame
)
