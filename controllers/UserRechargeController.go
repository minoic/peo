package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"time"
)

type UserRechargeController struct {
	beego.Controller
}

func (this *UserRechargeController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserRecharge.html"
	this.Data["i"] = 3
	this.Data["u"] = 3
}

func (this *UserRechargeController) Get() {
	user, _ := MinoSession.SessionGetUser(this.StartSession())
	DB := MinoDatabase.GetDatabase()
	var logs []MinoDatabase.RechargeLog
	DB.Where("user_id = ?", user.ID).Find(&logs)
	this.Data["rechargeLogs"] = logs
	this.Data["balance"] = user.Balance
}

func (this *UserRechargeController) RechargeByKey() {
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if bm.IsExist("RECHARGE_DELAY" + user.Name) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您 2 秒钟内只能充值一次"))
		return
	}
	keyString := this.Ctx.Input.Param(":key")
	DB := MinoDatabase.GetDatabase()
	var key MinoDatabase.RechargeKey
	if DB.Where("key = ?", keyString).First(&key).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无效的 KEY"))
		return
	}
	/* valid post */
	if err = DB.Model(&user).Update("balance", user.Balance+key.Balance).Error; err != nil {
		DB.Create(&MinoDatabase.RechargeKey{
			Model:   gorm.Model{},
			Key:     key.Key,
			Balance: key.Balance,
			Exp:     key.Exp,
		})
		_, _ = this.Ctx.ResponseWriter.Write([]byte("增加余额失败！"))
		return
	}
	err = bm.Put("RECHARGE_DELAY", 0, 2*time.Second)
	if err != nil {
		beego.Error(err)
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserRechargeController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.Ctx.Input.Query("_xsrf")
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Xsrftoken")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Csrftoken")
	}
	if token == "" {
		return false
	}
	if this.XSRFToken() != token {
		return false
	}
	return true
}
