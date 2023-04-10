package controllers

import (
	"context"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/session"
	"time"
)

type UserWorkOrderController struct {
	web.Controller
	i18n.Locale
}

func (this *UserWorkOrderController) Prepare() {
	if !session.Logged(this.StartSession()) {
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
	user, err := session.GetUser(this.StartSession())
	if err != nil || user == (database.User{}) {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if database.Redis().Get(context.Background(), "WORKORDER"+user.Name).Err() == nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您 10 秒钟只能发送一条工单"))
		return
	}
	database.Redis().Set(context.Background(), "WORKORDER"+user.Name, 0, 10*time.Second)
	title := this.GetString("title")
	text := this.GetString("text")
	if title == "" || text == "" {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("不能输入空值"))
		return
	}
	/* valid post */
	DB := database.Mysql()
	wo := database.WorkOrder{
		Model:      gorm.Model{},
		UserID:     user.ID,
		OrderTitle: title,
		OrderText:  text,
		UserName:   user.Name,
		Closed:     false,
	}
	if err = DB.Create(&wo).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("发送工单时数据库出现问题"))
		return
	}
	/* send messages to admin */
	go func() {
		var users []database.User
		DB.Where("is_admin = ?", true).Find(&users)
		for _, u := range users {
			message.Send("UserWorkOrderSystem", u.ID, "您有一个新的工单："+title)
			err = email.SendAnyEmail(user.Email, "您有一个新的工单："+title+" "+text)
			if err != nil {
				glgf.Error(err)
			}
		}
	}()
	/* end of send messages*/
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
