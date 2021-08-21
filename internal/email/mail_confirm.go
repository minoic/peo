package email

import (
	"errors"
	"github.com/jinzhu/gorm"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"time"
)

func ConfirmKey(key string) (database.User, bool) {
	DB := database.GetDatabase()
	var keyInfo database.RegConfirmKey
	if !DB.Where("KeyString = ?", key).First(&keyInfo).RecordNotFound() {
		if keyInfo.ValidTime.After(time.Now()) {
			var user database.User
			if !DB.Where("ID = ?", keyInfo.ID).First(&user).RecordNotFound() {
				user.EmailConfirmed = true
				DB.Model(&user).Update(database.User{
					EmailConfirmed: true,
				})
				return user, true
			}
		}
	}
	return database.User{}, false
}

func ConfirmRegister(user database.User) error {
	if user.EmailConfirmed {
		return errors.New("User Already confirmed! ")
	}
	key := database.RegConfirmKey{
		UserName:  user.Name,
		UserEmail: user.Email,
		Model:     gorm.Model{},
		KeyString: cryptoo.RandKey(15),
		UserID:    user.ID,
		ValidTime: time.Now().Add(30 * time.Minute),
	}
	DB := database.GetDatabase()
	DB.Create(&key)
	sendConfirmMail(key)
	return nil
}
