package MinoEmail

import (
	"errors"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoKey"
	"github.com/jinzhu/gorm"
	"time"
)

func ConfirmKey(key string) (MinoDatabase.User, bool) {
	DB := MinoDatabase.GetDatabase()
	var keyInfo MinoDatabase.RegConfirmKey
	if !DB.Where("Key = ?", key).First(&keyInfo).RecordNotFound() {
		if keyInfo.ValidTime.After(time.Now()) {
			var user MinoDatabase.User
			if !DB.Where("ID = ?", keyInfo.ID).First(&user).RecordNotFound() {
				user.EmailConfirmed = true
				DB.Model(&user).Update(MinoDatabase.User{
					EmailConfirmed: true,
				})
				return user, true
			}
		}
	}
	return MinoDatabase.User{}, false
}

func ConfirmRegister(user MinoDatabase.User) error {
	if user.EmailConfirmed {
		return errors.New("User Already confirmed! ")
	}
	key := MinoDatabase.RegConfirmKey{
		UserName:  user.Name,
		UserEmail: user.Email,
		Model:     gorm.Model{},
		Key:       MinoKey.RandKey(15),
		UserID:    user.ID,
		ValidTime: time.Now().Add(30 * time.Minute),
	}
	DB := MinoDatabase.GetDatabase()
	DB.Create(&key)
	sendConfirmMail(key)
	return nil
}
