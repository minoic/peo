package database

import (
	"fmt"
	"github.com/8treenet/gcache"
	gcopt "github.com/8treenet/gcache/option"
	"github.com/MinoIC/glgf"
	"github.com/MinoIC/peo/configure"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"time"
)

var db *gorm.DB

func connect() {
	defer func() {
		if err := recover(); err != nil {
			glgf.Error("panic caught:", fmt.Errorf("%v", err).Error())
			time.Sleep(3 * time.Second)
			connect()
		}
	}()
	conf := configure.GetConf()
	dialect := conf.String("Database")
	opt := gcopt.DefaultOption{}
	opt.PenetrationSafe = true
	opt.Level = gcopt.LevelModel
	switch dialect {
	case "SQLITE":
		DB, err := gorm.Open("sqlite3", "sqlite3.db")
		if err != nil {
			db = nil
			glgf.Error(err.Error())
		}
		db = DB
		if configure.UseGormCache {
			gcache.AttachDB(db, &opt, &gcopt.RedisOption{
				Addr: "localhost:6379",
			})
		}
		return
	case "MYSQL":
		DSN := conf.String("MYSQLUsername") + ":" +
			conf.String("MYSQLUserPassword") + "@(" +
			conf.String("MYSQLHost") + ")/" +
			conf.String("MYSQLDatabaseName") +
			"?charset=utf8&parseTime=True&loc=Local"
		glgf.Info("DSN: " + DSN)
		DB, err := gorm.Open("mysql", DSN)
		if err != nil {
			db = nil
			glgf.Error(err.Error())
		}
		db = DB
		if configure.UseGormCache {
			gcache.AttachDB(db, &opt, &gcopt.RedisOption{
				Addr: "localhost:6379",
			})
		}
		return
	}
	db = nil
	panic("CONF ERR: WRONG SQL DIALECT!!! " + dialect)
}

func GetDatabase() *gorm.DB {
	for db == nil {
		glgf.Warn("trying to connect to database!")
		connect()
	}
	for err := db.DB().Ping(); err != nil; err = db.DB().Ping() {
		glgf.Warn("trying to connect to database!")
		connect()
	}
	return db
}
