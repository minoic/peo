package MinoSession

import (
	"errors"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
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

func SessionIsAdmin(sess session.Store) bool {
	user, err := SessionGetUser(sess)
	if err != nil {
		beego.Error(err)
		return false
	}
	return user.IsAdmin
}

func SessionGetUser(sess session.Store) (MinoDatabase.User, error) {
	userID := int(sess.Get("ID").(uint))
	DB := MinoDatabase.GetDatabase()
	var user MinoDatabase.User
	if DB.Where("ID = ?", userID).First(&user).RecordNotFound() {
		return MinoDatabase.User{}, errors.New("cant find user: " + strconv.Itoa(userID))
	}
	if user == (MinoDatabase.User{}) {
		return user, errors.New("user struct is empty: " + strconv.Itoa(userID))
	}
	return user, nil
}

//todo: add support for redis/memcache
