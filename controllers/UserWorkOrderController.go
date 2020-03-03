package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"time"
)

type UserWorkOrderController struct {
	beego.Controller
}

func (this *UserWorkOrderController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserWorkOrder.html"
	this.Data["i"] = 4
	this.Data["u"] = 3
}

func (this *UserWorkOrderController) Get() {

}

func (this *UserWorkOrderController) NewWorkOrder() {
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil || user == (MinoDatabase.User{}) {
		beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if bm.IsExist("WORKORDER" + user.Name) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您 10 秒钟只能发送一条工单"))
		return
	}
	_ = bm.Put("WORKORDER"+user.Name, 0, 10*time.Second)
	title := this.GetString("title")
	text := this.GetString("text")
	if title == "" || text == "" {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("不能输入空值"))
		return
	}
	/* valid post */
	DB := MinoDatabase.GetDatabase()
	wo := MinoDatabase.WorkOrder{
		Model:      gorm.Model{},
		UserID:     user.ID,
		OrderTitle: title,
		OrderText:  text,
	}
	if err = DB.Create(&wo).Error; err != nil {
		beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("发送工单时数据库出现问题"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserWorkOrderController) CheckXSRFCookie() bool {
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
