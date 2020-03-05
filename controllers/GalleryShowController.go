package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/astaxie/beego"
)

type GalleryShowController struct {
	beego.Controller
}

func (this *GalleryShowController) Get() {
	this.TplName = "GalleryShow.html"
	handleNavbar(&this.Controller)
	this.Data["u"] = 5
	DB := MinoDatabase.GetDatabase()
	var items []MinoDatabase.GalleryItem
	DB.Find(&items)
	this.Data["items"] = items
}
