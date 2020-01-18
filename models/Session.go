package models

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/session"
)

func init() {
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.BConfig.WebConfig.Session.SessionProvider = "file"
	beego.BConfig.WebConfig.Session.SessionProviderConfig = "./tmp"
}

func Islogged(sess session.Store) bool {
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

func IsAdmin(sess session.Store) bool {
	userName := sess.Get("UN").(string)
	DB := GetDatabase()
	var user User
	if DB.Where("Name = ?", userName).First(&user).RecordNotFound() {
		beego.Error("cant find user: " + userName)
		return false
	}
	return user.IsAdmin
}
