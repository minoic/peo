package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/session"
)

type AdminConsoleUserController struct {
	web.Controller
	i18n.Locale
}

func (this *AdminConsoleUserController) Prepare() {
	this.TplName = "AdminConsoleUser.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !session.Logged(sess) {
		this.Abort("401")
	} else if !session.IsAdmin(sess) {
		this.Abort("401")
	}
	var users []database.User
	database.Mysql().Find(&users)
	this.Data["users"] = users
	glgf.Debug(users)
}

func (this *AdminConsoleUserController) Get() {

}
