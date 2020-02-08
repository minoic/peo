package MinoDatabase

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

func init() {
	DB := GetDatabase()
	defer DB.Close()
	DB.AutoMigrate(&User{}, &WareKey{}, &PEAdminSetting{}, &WareSpec{}, &RegConfirmKey{}, &WareEntity{}, &Message{})
	return
}

func GetDatabase() *gorm.DB {
	conf := MinoConfigure.GetConf()
	dialect := conf.String("Database")
	switch dialect {
	case "SQLITE":
		DB, err := gorm.Open("sqlite3", "sqlite3.db")
		if err != nil {
			panic(err.Error())
			return nil
		}
		return DB
	case "MYSQL":
		DSN := conf.String("MYSQLUsername") + ":" +
			conf.String("MYSQLUserPassword") + "@" +
			conf.String("MYSQLHost") + "/" +
			conf.String("MYSQLDatabaseName") +
			"?charset=utf8&parseTime=True&loc=Local"
		DB, err := gorm.Open("mysql", DSN)
		if err != nil {
			panic(err.Error())
			return nil
		}
		return DB
	}
	panic("CONF ERR: WRONG SQL DIALECT!!! " + dialect)
	return nil
}

//todo: test MYSQL
