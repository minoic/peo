package controllers

import (
	"github.com/MinoIC/peo/database"
	"github.com/astaxie/beego"
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
