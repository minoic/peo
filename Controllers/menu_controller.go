package Controllers

import (
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoMessage"
	"github.com/MinoIC/MinoIC-PE/MinoSession"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/MinoIC/glgf"
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
			glgf.Error(err)
		}
		this.Data["unReadNum"] = MinoMessage.UnReadNum(user.ID)
		this.Data["isAdmin"] = user.IsAdmin
	}
}

func handleSidebar(this *beego.Controller) {
	this.Data["dashboard"] = PterodactylAPI.ClientFromConf().HostName()
}
