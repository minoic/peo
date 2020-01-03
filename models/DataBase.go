package models

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

type User struct {
	gorm.Model
	Name     string
	Email    string
	Password string
}

func init() {
	DB, er := gorm.Open("sqlite3", "test.db")
	if er != nil {
		panic("Failed to connect database")
	}
	defer DB.Close()
	DB.AutoMigrate(&User{})
	return
}
