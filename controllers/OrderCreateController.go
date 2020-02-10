package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoOrder"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"strconv"
)

type OrderCreateController struct {
	beego.Controller
}

func (this *OrderCreateController) Prepare() {
	this.TplName = "Loading.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登陆页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
}

func (this *OrderCreateController) Get() {
	specID, err := this.GetUint32("specID", 0)
	if err != nil {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName(),
			Detail: "正在跳转到主页",
			Title:  "参数错误",
		}, &this.Controller)
	}
	var spec MinoDatabase.WareSpec
	DB := MinoDatabase.GetDatabase()
	if DB.Where("id = ?", specID).First(&spec).RecordNotFound() {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName(),
			Detail: "正在跳转到主页",
			Title:  "找不到此商品",
		}, &this.Controller)
	}
	sess := this.StartSession()
	user, err := MinoSession.SessionGetUser(sess)
	if err != nil {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转到登录页面",
			Title:  "请重新登录",
		}, &this.Controller)
		return
	}
	orderID := MinoOrder.SellCreate(uint(specID), user.ID)
	this.Redirect("/order/"+strconv.Itoa(int(orderID)), 302)
}
