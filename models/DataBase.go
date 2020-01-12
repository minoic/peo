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
}

type WareKey struct {
	gorm.Model
	WareID int
	Key    string
	Exp    time.Time
}

func init() {
	DB, err := gorm.Open("sqlite3", "test.db")
	if err != nil {
		panic(err.Error())
	}
	defer DB.Close()
	DB.AutoMigrate(&User{})
	DB.AutoMigrate(&WareKey{})
	return
}

func GetDatabase() *gorm.DB {
	DB, err := gorm.Open("sqlite3", "test.db")
	if err != nil {
		panic(err.Error())
	}
	return DB
}
