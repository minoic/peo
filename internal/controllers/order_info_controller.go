package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/orderform"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"strconv"
	"strings"
	"time"
)

type OrderInfoController struct {
	web.Controller
	i18n.Locale
}

func (this *OrderInfoController) Prepare() {
	this.TplName = "Order.html"
	this.Data["u"] = 0
	if !session.Logged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	orderIDString := this.Ctx.Input.Param(":orderID")
	orderID, _ := strconv.Atoi(orderIDString)
	DB := database.Mysql()
	var (
		spec  database.WareSpec
		order database.Order
	)
	if DB.Where("id = ?", orderID).First(&order).RecordNotFound() {
		this.Abort("404")
	}
	if DB.Where("id = ?", order.SpecID).First(&spec).RecordNotFound() {
		this.Abort("404")
	}
	sess := this.StartSession()
	user, err := session.GetUser(sess)
	if err != nil || user == (database.User{}) {
		this.Abort("401")
		return
	}
	if user.ID != order.UserID {
		this.Abort("401")
	}
	this.Data["userName"] = user.Name
	this.Data["userEmail"] = user.Email
	this.Data["wareName"] = spec.WareName
	this.Data["pricePerMonth"] = spec.PricePerMonth
	this.Data["orderID"] = order.ID
	this.Data["orderCreateTime"] = order.CreatedAt.Format("2006-01-02 15:04:05")
	this.Data["adminAddress"] = configure.Viper().GetString("WebAdminAddress")
	switch spec.ValidDuration {
	case 3 * 24 * time.Hour:
		this.Data["typeText"] = "试用"
	case 30 * 24 * time.Hour:
		this.Data["typeText"] = "月付"
	case 90 * 24 * time.Hour:
		this.Data["typeText"] = "季付"
	case 365 * 24 * time.Hour:
		this.Data["typeText"] = "年付"
	}
	this.Data["originPrice"] = order.OriginPrice
	this.Data["discountPrice"] = order.OriginPrice - order.FinalPrice
	this.Data["finalPrice"] = order.FinalPrice
	this.Data["paid"] = order.Paid
	this.Data["orderID"] = order.ID
	allocations, err := pterodactyl.ClientFromConf().GetAllocations(spec.Node)
	if err != nil {
		glgf.Error(err)
		this.Abort("500")
		return
	}
	type IPInfo struct {
		IP string
		ID int
	}
	var IPInfos []IPInfo
	// glgf.Info(allocations)
	for _, a := range allocations {
		IPInfos = append(IPInfos, IPInfo{
			IP: a.Alias + ":" + strconv.Itoa(a.Port),
			ID: a.ID,
		})
	}
	this.Data["ips"] = IPInfos
}

func (this *OrderInfoController) Get() {}

func (this *OrderInfoController) Post() {
	key := this.GetString("key")
	orderIDstring := this.Ctx.Input.Param(":orderID")
	orderIDint, _ := strconv.Atoi(orderIDstring)
	orderID := uint(orderIDint)
	selectedIP := this.GetString("selected_ip")
	arr := strings.Fields(selectedIP)
	id, err := strconv.Atoi(arr[0])
	// glgf.Info(id, arr[1])
	if err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "选取服务器地址失败！"
	}
	if err := orderform.SellPaymentCheck(orderID, key, id, arr[1]); err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "<< " + err.Error() + " >> 请联系网站管理员！"
	} else {
		this.Data["hasSuccess"] = true
		this.Redirect(this.Ctx.Request.URL.String(), 302)
	}
}

func (this *OrderInfoController) PayByBalance() {
	user, err := session.GetUser(this.StartSession())
	if err != nil || user == (database.User{}) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	orderID, err := strconv.Atoi(this.Ctx.Input.Param(":orderID"))
	if err != nil || orderID <= 0 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取表单"))
		return
	}
	var order database.Order
	DB := database.Mysql()
	if err = DB.Where("id = ?", orderID).First(&order).Error; err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取订单"))
		return
	}
	selectedIP := this.GetString("selected_ip")
	arr := strings.Fields(selectedIP)
	id, err := strconv.Atoi(arr[0])
	if err != nil || id < 0 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新选择 IP"))
		return
	}
	if order.Paid || order.Confirmed {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("订单已付款"))
		return
	}
	/* valid post */
	err = orderform.SellPaymentCheckByBalance(&order, &user, id, arr[1])
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(err.Error()))
	} else {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
	}
}
