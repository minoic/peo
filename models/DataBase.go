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
	DB, err := gorm.Open("sqlite3", "sqlite3.db")
	if err != nil {
		panic(err.Error())
	}
	defer DB.Close()
	DB.AutoMigrate(&User{}, &WareKey{}, &PEAdminSetting{}, &WareSpec{})
	return
}

func GetDatabase() *gorm.DB {
	DB, err := gorm.Open("sqlite3", "sqlite3.db")
	if err != nil {
		panic(err.Error())
	}
	return DB
}

//todo: add MYSQL and other SQLs
