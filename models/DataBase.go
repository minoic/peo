package models

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"time"
)

type User struct {
	gorm.Model
	Name     string
	Email    string
	Password string
	IsAdmin  bool
}

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

func init() {
	DB, err := gorm.Open("sqlite3", "sqlite3.db")
	if err != nil {
		panic(err.Error())
	}
	defer DB.Close()
	DB.AutoMigrate(&User{})
	DB.AutoMigrate(&WareKey{})
	DB.AutoMigrate(&PEAdminSetting{})
	return
}

func GetDatabase() *gorm.DB {
	DB, err := gorm.Open("sqlite3", "sqlite3.db")
	if err != nil {
		panic(err.Error())
	}
	return DB
}
