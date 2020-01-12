package models

import (
	"github.com/astaxie/beego"
	"github.com/robbert229/jwt"
	"time"
)

var AuthAlgo jwt.Algorithm

func init() {
	key := "xiCI^gi0!HE1kKZO6*W6k&SPS3$6jufiu*0T7$t!jUktm@#o"
	AuthAlgo = jwt.HmacSha512(key)
}

func GeneToken(username string) string {
	claims := jwt.NewClaim()
	claims.Set("username", username)
	claims.SetTime("end", time.Now().Add(30*24*time.Hour))
	if token, err := AuthAlgo.Encode(claims); err != nil {
		beego.Info("cant GeneToken for " + username)
		return ""
	} else {
		beego.Info("user:" + username + "`s token:" + token)
		return token
	}
}

func ValidateToken(utoken string, username string) bool {
	if AuthAlgo.Validate(utoken) != nil {
		return false
	}
	claims, err := AuthAlgo.Decode(utoken)
	if err != nil {
		beego.Info(err.Error())
		return false
	}
	tempName, _ := claims.Get("username")
	tokenName, ok := tempName.(string)
	if !ok {
		beego.Error(username + "`s tokenName is not a string!")
	}
	tokenTime, _ := claims.GetTime("end")
	beego.Info(tokenTime)
	if tokenName == username && time.Now().Before(tokenTime) {
		return true
	}
	return false
}
