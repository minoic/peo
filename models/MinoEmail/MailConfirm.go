package MinoEmail

import (
	"NTPE/models"
	"errors"
	"github.com/jinzhu/gorm"
	"time"
)

func ConfirmKey(key string) bool {
	DB := models.GetDatabase()
	defer DB.Close()
	var keyInfo models.RegConfirmKey
	if !DB.Where("Key = ?", key).First(&keyInfo).RecordNotFound() {
		if keyInfo.ValidTime.After(time.Now()) {
			var user models.User
			if !DB.Where("ID = ?", keyInfo.ID).First(&user).RecordNotFound() {
				user.EmailConfirmed = true
				DB.Model(&user).Update(models.User{
					EmailConfirmed: true,
				})
				return true
			}
		}
	}
	return false
}

func GenerateKey(user models.User) error {
	if user.EmailConfirmed {
		return errors.New("User Already confirmed! ")
	}
	key := models.RegConfirmKey{
		UserName:  user.Name,
		UserEmail: user.Email,
		Model:     gorm.Model{},
		Key:       models.RandKey(15),
		UserID:    user.ID,
		ValidTime: time.Now().Add(30 * time.Minute),
	}
	DB := models.GetDatabase()
	defer DB.Close()
	DB.Create(&key)
	SendConfirmMail(key)
	return nil
}
