package Controllers

import "github.com/astaxie/beego"

type CallbackController struct {
	beego.Controller
}

func (this *CallbackController) ZFBCallback() {
	tradeNo := this.Ctx.Input.Param(":tradeNo")
	beego.Info(tradeNo, "has been paid")

}
