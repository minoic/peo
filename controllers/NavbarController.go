package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

func handleNavbar(this *beego.Controller) {
	this.Data["webHostName"] = MinoConfigure.ConfGetHostName()
	this.Data["webApplicationName"] = MinoConfigure.ConfGetWebName()
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		this.Data["notLoggedIn"] = true
	} else {
		user, err := MinoSession.SessionGetUser(this.StartSession())
		if err != nil {
			beego.Error(err)
		}
		if user.IsAdmin {
			this.Data["isAdmin"] = true
		}
	}
}
