package models

import (
	"errors"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/session"
	"strconv"
)

func init() {
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.BConfig.WebConfig.Session.SessionProvider = "file"
	beego.BConfig.WebConfig.Session.SessionProviderConfig = "./tmp"
}

func SessionIslogged(sess session.Store) bool {
	cookie1 := sess.Get("LST")
	cookie2 := sess.Get("UN")
	if cookie1 == nil || cookie2 == nil {
		beego.Info("user doesnt have session")
		return false
	}
	lsToken := cookie1.(string)
	unToken := cookie2.(string)
	if len(lsToken) == 0 || !ValidateToken(lsToken, unToken) {
		beego.Info(lsToken, unToken)
		beego.Info(unToken + " not logged in!")
		return false
	} else {
		beego.Info(lsToken, unToken)
		beego.Info(unToken + " logged in!")
		return true
	}
}

func SessionGetUser(sess session.Store) (User, error) {
	userID := sess.Get("ID").(int)
	DB := GetDatabase()
	var user User
	if DB.Where("ID = ?", userID).First(&user).RecordNotFound() {
		return User{}, errors.New("cant find user: " + strconv.Itoa(userID))
	}
	return user, nil
}
