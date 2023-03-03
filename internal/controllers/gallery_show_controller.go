package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/peo/internal/database"
)

type GalleryShowController struct {
	web.Controller
}

func (this *GalleryShowController) Get() {
	this.TplName = "GalleryShow.html"
	handleNavbar(&this.Controller)
	this.Data["u"] = 5
	DB := database.Mysql()
	var items []database.GalleryItem
	DB.Where("review_passed = ?", true).Find(&items)
	this.Data["items"] = items
}
