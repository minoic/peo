package MinoDatabase

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

var db *gorm.DB

func connect() {
	conf := MinoConfigure.GetConf()
	dialect := conf.String("Database")
	switch dialect {
	case "SQLITE":
		DB, err := gorm.Open("sqlite3", "sqlite3.db")
		if err != nil {
			db = nil
			panic(err.Error())
		}
		db = DB
		return
	case "MYSQL":
		DSN := conf.String("MYSQLUsername") + ":" +
			conf.String("MYSQLUserPassword") + "@(" +
			conf.String("MYSQLHost") + ")/" +
			conf.String("MYSQLDatabaseName") +
			"?charset=utf8&parseTime=True&loc=Local"
		//beego.Debug(DSN)
		DB, err := gorm.Open("mysql", DSN)
		if err != nil {
			db = nil
			panic(err.Error())
		}
		db = DB
		return
	}
	db = nil
	panic("CONF ERR: WRONG SQL DIALECT!!! " + dialect)
}

func GetDatabase() *gorm.DB {
	for db == nil {
		connect()
		beego.Warn("trying to connect to database!")
	}
	if err := db.DB().Ping(); err != nil {
		connect()
		beego.Warn("trying to connect to database!")
	}
	return db
}

//todo: test MYSQL
