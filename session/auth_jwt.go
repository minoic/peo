package session

import (
	"github.com/MinoIC/glgf"
	"github.com/robbert229/jwt"
	"time"
)

var AuthAlgo jwt.Algorithm

func init() {
	key := "xiCI^gi0!HE1kKZO6*W6k&SPS3$6jufiu*0T7$t!jUktm@#o"
	AuthAlgo = jwt.HmacSha512(key)
}

func GeneToken(username string, remember bool) string {
	claims := jwt.NewClaim()
	claims.Set("username", username)
	if remember {
		claims.SetTime("exp", time.Now().AddDate(0, 2, 0))
	} else {
		claims.SetTime("exp", time.Now().AddDate(0, 0, 1))
	}
	if token, err := AuthAlgo.Encode(claims); err != nil {
		glgf.Error("cant GeneToken for " + username)
		return ""
	} else {
		// glgf.Info("user:" + username + "`s token:" + token)
		return token
	}
}

func ValidateToken(utoken string, username string) bool {
	if AuthAlgo.Validate(utoken) != nil {
		return false
	}
	claims, err := AuthAlgo.Decode(utoken)
	// glgf.Debug(claims)
	if err != nil {
		glgf.Error(err.Error())
		return false
	}
	tempName, _ := claims.Get("username")
	tokenName, ok := tempName.(string)
	if !ok {
		glgf.Error(username + "`s tokenName is not a string!")
	}
	tokenTime, _ := claims.GetTime("exp")
	// glgf.Info(tokenTime)
	if tokenName == username && time.Now().Before(tokenTime) {
		return true
	}
	return false
}
