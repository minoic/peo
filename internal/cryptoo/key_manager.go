package cryptoo

import (
	"github.com/jinzhu/gorm"
	"github.com/minoic/peo/internal/database"
	"time"
)

func GeneKeys(keyAmount int, wareID uint, validityTermInDay int, keyLength int) error {
	DB := database.GetDatabase()
	for i := 1; i <= keyAmount; i++ {
		newKey := database.WareKey{
			Model:     gorm.Model{},
			SpecID:    wareID,
			KeyString: RandKey(keyLength),
			Exp:       time.Now().AddDate(0, 0, validityTermInDay),
		}
		if err := DB.Create(&newKey).Error; err != nil {
			return err
		}
	}
	return nil
}

func GeneRechargeKeys(keyAmount int, balance uint, validityTermInDay int, keyLength int) error {
	DB := database.GetDatabase()
	for i := 1; i <= keyAmount; i++ {
		newKey := database.RechargeKey{
			Model:     gorm.Model{},
			KeyString: RandKey(keyLength),
			Balance:   balance,
			Exp:       time.Now().AddDate(0, 0, validityTermInDay),
		}
		if err := DB.Create(&newKey).Error; err != nil {
			return err
		}
	}
	return nil
}

func DeleteOutdatedKeys() {
	DB := database.GetDatabase()
	/* ware keys*/
	var keys []database.WareKey
	DB.Find(&keys)
	for _, k := range keys {
		if k.Exp.Before(time.Now()) {
			DB.Delete(&k)
		}
	}
	/* recharge keys */
	var rkeys []database.RechargeKey
	DB.Find(&rkeys)
	for _, k := range keys {
		if k.Exp.Before(time.Now()) {
			DB.Delete(&k)
		}
	}
}
