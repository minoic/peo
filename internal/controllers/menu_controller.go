package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/session"
	"github.com/spf13/cast"
	"html/template"
)

func handleNavbar(this *web.Controller) {
	this.Data["xsrfData"] = template.HTML(this.XSRFFormHTML())
	this.Data["webHostName"] = configure.Viper().GetString("WebHostName")
	this.Data["webApplicationName"] = configure.Viper().GetString("WebApplicationName")
	this.Data["webApplicationAuthor"] = "minoic <minoic2020@gmail.com>"
	this.Data["webDescription"] = configure.Viper().GetString("webDescription")
	this.Data["AlbumEnabled"] = cast.ToBool(configure.Viper().GetString("AlbumEnabled"))
	sess := this.StartSession()
	if !session.Logged(sess) {
		this.Data["notLoggedIn"] = true
	} else {
		user, err := session.GetUser(sess)
		if err != nil {
			glgf.Error(err)
		}
		this.Data["unReadNum"] = message.UnReadNum(user.ID)
		this.Data["isAdmin"] = user.IsAdmin
	}
	link := configure.Viper().GetString("SocialLink")
	this.Data["linkEnabled"] = len(link) != 0
	this.Data["link"] = link
	this.Data["linkTitle"] = configure.Viper().GetString("SocialLinkTitle")
}

func handleSidebar(this *web.Controller) {
	this.Data["dashboard"] = "/delay/login"
}
