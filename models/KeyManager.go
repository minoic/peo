package models

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/jinzhu/gorm"
	"math/rand"
	"time"
)

func RandKey(keyLength int) string {
	str := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	b := []byte(str)
	var ret []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 1; i <= keyLength; i++ {
		ret = append(ret, b[r.Intn(len(str))])
	}
	return string(ret)
}

func GeneKeys(keyAmount int, wareID uint, validityTermInDay int, keyLength int) {
	DB := MinoDatabase.GetDatabase()
	defer DB.Close()
	for i := 1; i <= keyAmount; i++ {
		newKey := MinoDatabase.WareKey{
			Model:  gorm.Model{},
			WareID: wareID,
			Key:    RandKey(keyLength),
			Exp:    time.Now().AddDate(0, 0, validityTermInDay),
		}
		DB.Create(&newKey)
	}
}
