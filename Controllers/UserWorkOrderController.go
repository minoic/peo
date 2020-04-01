package Controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/MinoEmail"
	"git.ntmc.tech/root/MinoIC-PE/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/MinoSession"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"time"
)

type UserWorkOrderController struct {
	beego.Controller
}

func (this *UserWorkOrderController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		this.Abort("401")
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
		UserName:   user.Name,
		Closed:     false,
	}
	if err = DB.Create(&wo).Error; err != nil {
		beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("发送工单时数据库出现问题"))
		return
	}
	/* send messages to admin */
	go func() {
		var users []MinoDatabase.User
		DB.Where("is_admin = ?", true).Find(&users)
		for _, u := range users {
			MinoMessage.Send("UserWorkOrderSystem", u.ID, "您有一个新的工单："+title)
			err = MinoEmail.SendAnyEmail(user.Email, "您有一个新的工单："+title+" "+text)
			if err != nil {
				beego.Error(err)
			}
		}
	}()
	/* end of send messages*/
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
