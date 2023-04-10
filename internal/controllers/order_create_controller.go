package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/orderform"
	"github.com/minoic/peo/internal/session"
	"strconv"
)

type OrderCreateController struct {
	web.Controller
	i18n.Locale
}

func (this *OrderCreateController) Prepare() {
	this.TplName = "Loading.html"
	if !session.Logged(this.StartSession()) {
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
	DB := database.Mysql()
	if DB.Where("id = ?", specID).First(&spec).RecordNotFound() {
		this.Abort("404")
	}
	sess := this.StartSession()
	user, err := session.GetUser(sess)
	if err != nil {
		this.Abort("401")
		return
	}
	orderID := orderform.SellCreate(uint(specID), user.ID)
	this.Redirect("/order/"+strconv.Itoa(int(orderID)), 302)
}
