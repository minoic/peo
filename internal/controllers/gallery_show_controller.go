package controllers

import (
	"github.com/astaxie/beego"
	"github.com/minoic/peo/internal/database"
)

type GalleryShowController struct {
	beego.Controller
}

func (this *GalleryShowController) Get() {
	this.TplName = "GalleryShow.html"
	handleNavbar(&this.Controller)
	this.Data["u"] = 5
	DB := database.GetDatabase()
	var items []database.GalleryItem
	DB.Where("review_passed = ?", true).Find(&items)
	this.Data["items"] = items
}
