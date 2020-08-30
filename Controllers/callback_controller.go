package Controllers

import (
	"fmt"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoMessage"
	"github.com/MinoIC/glgf"
	"github.com/astaxie/beego"
	"strings"
)

type CallbackController struct {
	beego.Controller
}

func (this *CallbackController) Prepare() {
	this.EnableXSRF = false
	this.EnableRender = false
}

func (this *CallbackController) Post() {
	notify, err := MinoConfigure.AliClient.GetTradeNotification(this.Ctx.Request)
	if err != nil {
		glgf.Error(err)
		return
	}
	glgf.Debug(notify)
	if notify.TradeStatus != "TRADE_SUCCESS" {
		glgf.Error(notify.TradeStatus)
		return
	}
	DB := MinoDatabase.GetDatabase()
	var (
		rlog MinoDatabase.RechargeLog
		user MinoDatabase.User
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
	DB.Model(&rlog).Update(&MinoDatabase.RechargeLog{
		Code:   rlog.Code[:23] + fmt.Sprintf("%d_%d_Finished", user.Balance-rlog.Balance, user.Balance),
		Status: `<span class="label label-success">已到账</span>`,
	})
	glgf.Info("user", user.Name, user.Email, "has recharged ", rlog.Balance)
	MinoMessage.SendAdmin("user", user.Name, user.Email, "has recharged ", rlog.Balance)
	this.Ctx.WriteString("success")
}
