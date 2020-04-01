package Controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/MinoOrder"
	"git.ntmc.tech/root/MinoIC-PE/MinoSession"
	"github.com/astaxie/beego"
	"strconv"
)

type OrderCreateController struct {
	beego.Controller
}

func (this *OrderCreateController) Prepare() {
	this.TplName = "Loading.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
}

func (this *OrderCreateController) Get() {
	specID, err := this.GetUint32("specID", 0)
	if err != nil {
		this.Abort("400")
	}
	var spec MinoDatabase.WareSpec
	DB := MinoDatabase.GetDatabase()
	if DB.Where("id = ?", specID).First(&spec).RecordNotFound() {
		this.Abort("404")
	}
	sess := this.StartSession()
	user, err := MinoSession.SessionGetUser(sess)
	if err != nil {
		this.Abort("401")
		return
	}
	orderID := MinoOrder.SellCreate(uint(specID), user.ID)
	this.Redirect("/order/"+strconv.Itoa(int(orderID)), 302)
}
