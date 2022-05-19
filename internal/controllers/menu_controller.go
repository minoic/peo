package controllers

import (
	"github.com/astaxie/beego"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"html/template"
)

func handleNavbar(this *beego.Controller) {
	conf := configure.GetConf()
	this.Data["xsrfData"] = template.HTML(this.XSRFFormHTML())
	this.Data["webHostName"] = configure.WebHostName
	this.Data["webApplicationName"] = configure.WebApplicationName
	this.Data["webApplicationAuthor"] = "CytusD <cytusd@outlook.com>"
	this.Data["webDescription"] = conf.String("webDescription")
	this.Data["AlbumEnabled"] = conf.String("AlbumEnabled")
	sess := this.StartSession()
	if !session.SessionIslogged(sess) {
		this.Data["notLoggedIn"] = true
	} else {
		user, err := session.SessionGetUser(sess)
		if err != nil {
			glgf.Error(err)
		}
		this.Data["unReadNum"] = message.UnReadNum(user.ID)
		this.Data["isAdmin"] = user.IsAdmin
	}
}

func handleSidebar(this *beego.Controller) {
	this.Data["dashboard"] = pterodactyl.ClientFromConf().HostName()
}
