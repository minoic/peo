package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoCache"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoEmail"
	"github.com/astaxie/beego"
	"time"
)

type ForgetPasswordMailController struct {
	beego.Controller
}

var bm = MinoCache.GetCache()

func (this *ForgetPasswordMailController) Get() {
	this.TplName = "Index.html"
	userEmail := this.Ctx.Input.Param(":email")
	DB := MinoDatabase.GetDatabase()
	if DB.Where("email = ?", userEmail).First(&MinoDatabase.User{}).RecordNotFound() || bm.IsExist("FORGET"+userEmail) {
		return
	}
	key, err := MinoEmail.SendCaptcha(userEmail)
	if err != nil {
		beego.Error(err)
	} else {
		err := bm.Put("FORGET"+userEmail, key, 1*time.Minute)
		if err != nil {
			beego.Error(err)
		}
	}
}
