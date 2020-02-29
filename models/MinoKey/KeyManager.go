package MinoKey

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/jinzhu/gorm"
	"time"
)

func GeneKeys(keyAmount int, wareID uint, validityTermInDay int, keyLength int) error {
	DB := MinoDatabase.GetDatabase()
	for i := 1; i <= keyAmount; i++ {
		newKey := MinoDatabase.WareKey{
			Model:  gorm.Model{},
			SpecID: wareID,
			Key:    RandKey(keyLength),
			Exp:    time.Now().AddDate(0, 0, validityTermInDay),
		}
		if err := DB.Create(&newKey).Error; err != nil {
			return err
		}
	}
	return nil
}

func GeneRechargeKeys(keyAmount int, balance uint, validityTermInDay int, keyLength int) error {
	DB := MinoDatabase.GetDatabase()
	for i := 1; i <= keyAmount; i++ {
		newKey := MinoDatabase.RechargeKey{
			Model:   gorm.Model{},
			Key:     RandKey(keyLength),
			Balance: balance,
			Exp:     time.Now().AddDate(0, 0, validityTermInDay),
		}
		if err := DB.Create(&newKey).Error; err != nil {
			return err
		}
	}
	return nil
}

func DeleteOutdatedKeys() {
	DB := MinoDatabase.GetDatabase()
	/* ware keys*/
	var keys []MinoDatabase.WareKey
	DB.Find(&keys)
	for _, k := range keys {
		if k.Exp.Before(time.Now()) {
			DB.Delete(&k)
		}
	}
	/* recharge keys */
	var rkeys []MinoDatabase.RechargeKey
	DB.Find(&rkeys)
	for _, k := range keys {
		if k.Exp.Before(time.Now()) {
			DB.Delete(&k)
		}
	}
}
