package MinoSession

import (
	"errors"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/glgf"
	"github.com/astaxie/beego/session"
	_ "github.com/astaxie/beego/session/memcache"
	_ "github.com/astaxie/beego/session/mysql"
	_ "github.com/astaxie/beego/session/redis"
	"strconv"
)

func init() {

}

func SessionIslogged(sess session.Store) bool {
	cookie1 := sess.Get("LST")
	cookie2 := sess.Get("UN")
	if cookie1 == nil || cookie2 == nil {
		// glgf.Info("user doesnt have session")
		return false
	}
	lsToken := cookie1.(string)
	unToken := cookie2.(string)
	if MinoDatabase.GetDatabase().First(&MinoDatabase.User{}, "name = ?", unToken).RecordNotFound() {
		return false
	}
	// glgf.Debug(lsToken, unToken)
	if len(lsToken) == 0 || !ValidateToken(lsToken, unToken) {
		glgf.Warn(unToken + " is not logged in!")
		return false
	} else {
		// glgf.Info(unToken + " is logged in!")
		return true
	}
}

func SessionIsAdmin(sess session.Store) bool {
	user, err := SessionGetUser(sess)
	if err != nil {
		glgf.Error(err)
		return false
	}
	return user.IsAdmin
}

func SessionGetUser(sess session.Store) (MinoDatabase.User, error) {
	id := sess.Get("ID")
	if id == nil {
		return MinoDatabase.User{}, errors.New("user doesnt have session")
	}
	userID := int(id.(uint))
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
