package Controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/PterodactylAPI"
	"github.com/astaxie/beego"
	"html/template"
)

func handleNavbar(this *beego.Controller) {
	conf := MinoConfigure.GetConf()
	this.Data["xsrfData"] = template.HTML(this.XSRFFormHTML())
	this.Data["webHostName"] = MinoConfigure.WebHostName
	this.Data["webApplicationName"] = MinoConfigure.WebApplicationName
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
