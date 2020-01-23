package models

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	uuid "github.com/satori/go.uuid"
	"time"
)

type User struct {
	gorm.Model
	Name     string
	Email    string
	Password string
	IsAdmin  bool
	UUID     uuid.UUID `gorm:"not null;unique"`
}

//todo: encrypt user`s password

type WareKey struct {
	gorm.Model
	WareID int
	Key    string
	Exp    time.Time
}

type PEAdminSetting struct {
	gorm.Model
	Key   string
	Value string
}

type WareSpec struct {
	gorm.Model
	WareName          string
	WareDescription   string
	Memory            int
	Cpu               int
	Swap              int
	Disk              int
	Io                int
	Nest              int
	Egg               int
	StartOnCompletion bool
	OomDisabled       bool
	DockerImage       string
	ValidDuration     time.Duration
	DeleteDuration    time.Duration
}

func init() {
	DB := GetDatabase()
	defer DB.Close()
	DB.AutoMigrate(&User{}, &WareKey{}, &PEAdminSetting{}, &WareSpec{})
	return
}

func GetDatabase() *gorm.DB {
	conf := getConf()
	dialect := conf.String("sql::Database")
	switch dialect {
	case "SQLITE":
		DB, err := gorm.Open("sqlite3", "sqlite3.db")
		if err != nil {
			panic(err.Error())
			return nil
		}
		return DB
	case "MYSQL":
		DSN := conf.String("sql::MYSQLUsername") + ":" +
			conf.String("sql::MYSQLUserPassword") + "@" +
			conf.String("sql::MYSQLHost") + "/" +
			conf.String("sql::MYSQLDatabaseName") +
			"?charset=utf8&parseTime=True&loc=Local"
		DB, err := gorm.Open("mysql", DSN)
		if err != nil {
			panic(err.Error())
			return nil
		}
		return DB
	}
	panic("CONF ERR: WRONG SQL DIALECT!!!")
	return nil
}

//todo: test MYSQL
