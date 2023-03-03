package session

import (
	"context"
	"errors"
	"github.com/beego/beego/v2/server/web/session"
	_ "github.com/beego/beego/v2/server/web/session/redis"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/database"
	"strconv"
)

func Logged(sess session.Store) bool {
	if sess == nil {
		return false
	}
	cookie1 := sess.Get(context.Background(), "LST")
	cookie2 := sess.Get(context.Background(), "UN")
	if cookie1 == nil || cookie2 == nil {
		// glgf.Info("user doesnt have session")
		return false
	}
	lsToken := cookie1.(string)
	unToken := cookie2.(string)
	if database.Mysql().First(&database.User{}, "name = ?", unToken).RecordNotFound() {
		return false
	}
	// glgf.Debug(lsToken, unToken)
	if len(lsToken) == 0 || !ValidateToken(lsToken, unToken) {

		return false
	}
	return true

}

func IsAdmin(sess session.Store) bool {
	user, err := GetUser(sess)
	if err != nil {
		glgf.Error(err)
		return false
	}
	return user.IsAdmin
}

func GetUser(sess session.Store) (database.User, error) {
	id := sess.Get(context.Background(), "ID")
	if id == nil {
		return database.User{}, errors.New("user doesnt have session")
	}
	userID := int(id.(uint))
	DB := database.Mysql()
	var user database.User
	if DB.Where("ID = ?", userID).First(&user).RecordNotFound() {
		return database.User{}, errors.New("cant find user: " + strconv.Itoa(userID))
	}
	if user == (database.User{}) {
		return user, errors.New("user struct is empty: " + strconv.Itoa(userID))
	}
	return user, nil
}
