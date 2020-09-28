package controllers

import (
	"github.com/MinoIC/MinoIC-PE/database"
	"github.com/MinoIC/MinoIC-PE/orderform"
	"github.com/MinoIC/MinoIC-PE/session"
	"github.com/astaxie/beego"
	"strconv"
)

type OrderCreateController struct {
	beego.Controller
}

func (this *OrderCreateController) Prepare() {
	this.TplName = "Loading.html"
	if !session.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
}

func (this *OrderCreateController) Get() {
	specID, err := this.GetUint32("specID", 0)
	if err != nil {
		this.Abort("400")
	}
	var spec database.WareSpec
	DB := database.GetDatabase()
	if DB.Where("id = ?", specID).First(&spec).RecordNotFound() {
		this.Abort("404")
	}
	sess := this.StartSession()
	user, err := session.SessionGetUser(sess)
	if err != nil {
		this.Abort("401")
		return
	}
	orderID := orderform.SellCreate(uint(specID), user.ID)
	this.Redirect("/order/"+strconv.Itoa(int(orderID)), 302)
}
