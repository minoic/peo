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

func handleNavbar(controller *web.Controller) {
	controller.Data["xsrfData"] = template.HTML(controller.XSRFFormHTML())
	controller.Data["webHostName"] = configure.Viper().GetString("WebHostName")
	controller.Data["webApplicationName"] = configure.Viper().GetString("WebApplicationName")
	controller.Data["webApplicationAuthor"] = "minoic <minoic2020@gmail.com>"
	controller.Data["webDescription"] = configure.Viper().GetString("webDescription")
	controller.Data["AlbumEnabled"] = cast.ToBool(configure.Viper().GetString("AlbumEnabled"))
	sess := controller.StartSession()
	if !session.Logged(sess) {
		controller.Data["notLoggedIn"] = true
	} else {
		user, err := session.GetUser(sess)
		if err != nil {
			glgf.Error(err)
		}
		controller.Data["unReadNum"] = message.UnReadNum(user.ID)
		controller.Data["isAdmin"] = user.IsAdmin
	}
	link := configure.Viper().GetString("SocialLink")
	controller.Data["linkEnabled"] = len(link) != 0
	controller.Data["link"] = link
	controller.Data["linkTitle"] = configure.Viper().GetString("SocialLinkTitle")
}

func handleSidebar(controller *web.Controller) {
	controller.Data["dashboard"] = "/delay/login"
}
