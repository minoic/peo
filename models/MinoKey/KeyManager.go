package MinoKey

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/jinzhu/gorm"
	"time"
)

func GeneKeys(keyAmount int, wareID uint, validityTermInDay int, keyLength int) {
	DB := MinoDatabase.GetDatabase()
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
