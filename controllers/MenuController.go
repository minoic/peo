package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"html/template"
)

func handleNavbar(this *beego.Controller) {
	conf := MinoConfigure.GetConf()
	this.Data["xsrfData"] = template.HTML(this.XSRFFormHTML())
	this.Data["webHostName"] = MinoConfigure.ConfGetHostName()
	this.Data["webApplicationName"] = MinoConfigure.ConfGetWebName()
	this.Data["webApplicationAuthor"] = "CytusD <cytusd@outlook.com>"
	this.Data["webDescription"] = conf.String("webDescription")
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		this.Data["notLoggedIn"] = true
	} else {
		user, err := MinoSession.SessionGetUser(sess)
		if err != nil {
			beego.Error(err)
		}
		this.Data["unReadNum"] = MinoMessage.UnReadNum(user.ID)
		if user.IsAdmin {
			this.Data["isAdmin"] = true
		}
	}
}

func handleSidebar(this *beego.Controller) {
	this.Data["dashboard"] = PterodactylAPI.PterodactylGethostname(PterodactylAPI.ConfGetParams())

}
