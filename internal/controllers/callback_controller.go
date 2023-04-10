package controllers

import (
	"fmt"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/message"
	"strings"
)

type CallbackController struct {
	web.Controller
	i18n.Locale
}

func (this *CallbackController) Prepare() {
	this.EnableRender = false
	this.Data["lang"] = configure.Viper().GetString("Language")
}

func (this *CallbackController) Post() {
	if configure.AliClient == nil {
		this.Abort("403")
		return
	}
	notify, err := configure.AliClient.GetTradeNotification(this.Ctx.Request)
	if err != nil {
		glgf.Error(err)
		return
	}
	glgf.Debug(notify)
	if notify.TradeStatus != "TRADE_SUCCESS" {
		glgf.Error(notify.TradeStatus)
		return
	}
	DB := database.Mysql()
	var (
		rlog database.RechargeLog
		user database.User
	)
	if err = DB.First(&rlog, "out_trade_no = ?", notify.OutTradeNo).Error; err != nil {
		glgf.Error(err)
		return
	}
	if strings.Contains(rlog.Code, "Finished") {
		this.Ctx.WriteString("success")
		return
	}
	if err = DB.First(&user, "id = ?", rlog.UserID).Error; err != nil {
		glgf.Error(err)
		return
	}
	if err = DB.Model(&user).Update("balance", user.Balance+rlog.Balance).Error; err != nil {
		glgf.Error(err)
		return
	}
	DB.Model(&rlog).Update(&database.RechargeLog{
		Code:   rlog.Code[:23] + fmt.Sprintf("%d_%d_Finished", user.Balance-rlog.Balance, user.Balance),
		Status: `<span class="label label-success">已到账</span>`,
	})
	glgf.Info("user", user.Name, user.Email, "has recharged ", rlog.Balance)
	message.SendAdmin("user", user.Name, user.Email, "has recharged ", rlog.Balance)
	this.Ctx.WriteString("success")
}
