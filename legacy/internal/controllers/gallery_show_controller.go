package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/peo/internal/database"
)

type GalleryShowController struct {
	web.Controller
	i18n.Locale
}

func (this *GalleryShowController) Prepare() {
	this.TplName = "GalleryShow.html"
	this.Data["u"] = 5
	handleNavbar(&this.Controller)

}

func (this *GalleryShowController) Get() {
	DB := database.Mysql()
	var items []database.GalleryItem
	DB.Where("review_passed = ?", true).Find(&items)
	this.Data["items"] = items
}
