package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoEmail"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
)

type ConfirmController struct {
	beego.Controller
}

func (this *ConfirmController) Get() {
	key := this.Ctx.Input.Param(":key")
	user, ok := MinoEmail.ConfirmKey(key)
	if ok {
		if MinoConfigure.ConfGetSMTPEnabled() {
			err := PterodactylAPI.PterodactylCreateUser(PterodactylAPI.ConfGetParams(), PterodactylAPI.PostPteUser{
				ExternalId: user.Name,
				Username:   user.Name,
				Email:      user.Email,
				Language:   "zh",
				RootAdmin:  user.IsAdmin,
				Password:   user.Name,
				FirstName:  user.Name,
				LastName:   "_",
			})
			if err != nil {
				beego.Error("cant create pterodactyl user for " + user.Name)
				MinoMessage.Send("ADMIN", user.ID, "为您创建控制台账户失败，请先确认成功创建再购买服务器！")
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.ConfGetHostName() + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功，但开户失败，请联系网站管理员！",
				}, &this.Controller)
				//todo:remind user to rebuild pterodactyl account
			} else {
				MinoMessage.Send("ADMIN", user.ID, "已为您成功创建控制台账户，可以购买服务器了！")
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.ConfGetHostName() + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功！",
				}, &this.Controller)
			}
		} else {
			DelayRedirect(DelayInfo{
				URL:    MinoConfigure.ConfGetHostName() + "/login",
				Detail: "即将跳转到登陆页面",
				Title:  "注册验证成功！",
			}, &this.Controller)
		}
	} else {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册验证失败！请重新验证！",
		}, &this.Controller)
	}
	this.TplName = "Delay.html"
}
