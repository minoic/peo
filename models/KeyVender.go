package models

import (
	"github.com/jinzhu/gorm"
	"math/rand"
	"time"
)

func randKey(keyLength int) string {
	str := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	b := []byte(str)
	var ret []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 1; i <= keyLength; i++ {
		ret = append(ret, b[r.Intn(len(str))])
	}
	return string(ret)
}

func GeneKeys(keyAmount int, wareID int, validityTermInDay int, keyLength int) {
	DB := GetDatabase()
	defer DB.Close()
	for i := 1; i <= keyAmount; i++ {
		newKey := WareKey{
			Model:  gorm.Model{},
			WareID: wareID,
			Key:    randKey(keyLength),
			Exp:    time.Now().AddDate(0, 0, validityTermInDay),
		}
		DB.Create(&newKey)
	}
}
