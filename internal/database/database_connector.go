package database

import (
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/redis/go-redis/v9"
	"time"
)

var (
	rdb *redis.Client
	db  *gorm.DB
)

func connect() {
	defer func() {
		if err := recover(); err != nil {
			glgf.Error("panic caught:", fmt.Errorf("%v", err).Error())
			time.Sleep(3 * time.Second)
			connect()
		}
	}()
	DSN := fmt.Sprintf("%s:%s@(%s)/%s?charset=utf8&parseTime=True&loc=Local", configure.Viper().GetString("MYSQLUsername"),
		configure.Viper().GetString("MYSQLUserPassword"), configure.Viper().GetString("MYSQLHost"), configure.Viper().GetString("MYSQLDatabaseName"))
	glgf.Debug(DSN)
	DB, err := gorm.Open("mysql", DSN)
	if err != nil {
		db = nil
		glgf.Error(err)
		return
	}
	db = DB
}

func Mysql() *gorm.DB {
	for db == nil {
		glgf.Warn("Trying to connect to database!")
		time.Sleep(3 * time.Second)
		connect()
	}
	for err := db.DB().Ping(); err != nil; err = db.DB().Ping() {
		glgf.Warn("Trying to connect to database!")
		time.Sleep(3 * time.Second)
		connect()
	}
	return db
}

func Redis() *redis.Client {
	if rdb == nil {
		rdb = redis.NewClient(&redis.Options{
			Addr:        configure.Viper().GetString("RedisHost"),
			DialTimeout: 3 * time.Second,
			DB:          configure.Viper().GetInt("RedisDB"),
			Password:    configure.Viper().GetString("RedisPassword"),
		})
	}
	return rdb
}

func Reset() {
	rdb = nil
	db = nil
}
