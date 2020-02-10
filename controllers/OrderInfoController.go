package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoOrder"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"strconv"
	"time"
)

type OrderInfoController struct {
	beego.Controller
}

func (this *OrderInfoController) Prepare() {
	this.TplName = "Order.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登陆页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
}

func (this *OrderInfoController) Get() {
	orderIDstring := this.Ctx.Input.Param(":orderID")
	orderID, _ := strconv.Atoi(orderIDstring)
	DB := MinoDatabase.GetDatabase()
	var (
		spec  MinoDatabase.WareSpec
		order MinoDatabase.Order
	)
	if DB.Where("id = ?", orderID).First(&order).RecordNotFound() {
		DelayRedirect(DelayInfo{
			URL:    this.Ctx.Request.Referer(),
			Detail: "正在跳转到之前的页面",
			Title:  "找不到此订单",
		}, &this.Controller)
	}
	/*	order=MinoDatabase.Order{
		Model:        gorm.Model{
			ID:        333,
			CreatedAt: time.Now(),
			UpdatedAt: time.Time{},
			DeletedAt: nil,
		},
		SpecID:       2,
		UserID:       1,
		AllocationID: 12,
		OriginPrice:  100,
		FinalPrice:   80,
		Paid:         false,
		Confirmed:    false,
	}*/
	if DB.Where("id = ?", order.SpecID).First(&spec).RecordNotFound() {
		DelayRedirect(DelayInfo{
			URL:    this.Ctx.Request.Referer(),
			Detail: "正在跳转到之前的页面",
			Title:  "找不到指定商品！",
		}, &this.Controller)
	}
	sess := this.StartSession()
	user, err := MinoSession.SessionGetUser(sess)
	if err != nil || user == (MinoDatabase.User{}) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转到登录页面",
			Title:  "请重新登录",
		}, &this.Controller)
		return
	}
	if user.ID != order.UserID {
		DelayRedirect(DelayInfo{
			URL:    this.Ctx.Request.Referer(),
			Detail: "正在跳转到之前的页面",
			Title:  "您无权访问此订单",
		}, &this.Controller)
	}
	this.Data["userName"] = user.Name
	this.Data["userEmail"] = user.Email
	this.Data["wareName"] = spec.WareName
	this.Data["pricePerMonth"] = spec.PricePerMonth
	this.Data["orderID"] = order.ID
	this.Data["orderCreateTime"] = order.CreatedAt.Format("2006-01-02 15:04:05")
	this.Data["adminAddress"] = MinoConfigure.ConfGetAdminAddress()
	switch spec.ValidDuration {
	case 3 * 24 * time.Hour:
		this.Data["typeText"] = "试用"
	case 30 * 24 * time.Hour:
		this.Data["typeText"] = "月付"
	case 90 * 24 * time.Hour:
		this.Data["typeText"] = "季付"
	}
	this.Data["originPrice"] = order.OriginPrice
	this.Data["discountPrice"] = order.OriginPrice - order.FinalPrice
	this.Data["finalPrice"] = order.FinalPrice
	this.Data["paid"] = order.Paid
}

func (this *OrderInfoController) Post() {
	key := this.GetString("key")
	orderIDstring := this.Ctx.Input.Param(":orderID")
	orderIDint, _ := strconv.Atoi(orderIDstring)
	orderID := uint(orderIDint)
	if err := MinoOrder.SellPaymentCheck(orderID, key); err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "激活失败：" + err.Error() + " 请联系网站管理员！"
	} else {
		this.Redirect(this.Ctx.Request.URL.String(), 302)
	}
}
