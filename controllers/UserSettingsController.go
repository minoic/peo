package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type UserSettingsController struct {
	beego.Controller
}

func (this *UserSettingsController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserSettings.html"
	this.Data["i"] = 2
	this.Data["u"] = 3
}

func (this *UserSettingsController) Get() {}

func (this *UserSettingsController) UpdateUserPassword() {
	oldPassword := this.GetString("oldPassword")
	newPassword := this.GetString("newPassword")
	confirmPassword := this.GetString("confirmPassword")
	DB := MinoDatabase.GetDatabase()
	conf := MinoConfigure.GetConf()
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = err.Error() + " 获取用户信息失败，请重新登录！"
		this.Redirect("/user-settings", 302)
		return
	}
	b := md5.Sum([]byte(oldPassword + conf.String("DatabaseSalt")))
	if hex.EncodeToString(b[:]) == user.Password {
		if newPassword == confirmPassword {
			b2 := md5.Sum([]byte(newPassword + conf.String("DatabaseSalt")))
			DB.Model(&user).Update("password", hex.EncodeToString(b2[:]))
			this.Data["hasSuccess"] = true
			MinoMessage.Send("ADMIN", user.ID, "您刚刚成功修改了密码！")
			this.Redirect("/user-settings", 302)
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "两次输入的新密码不一致"
			//this.Redirect("/user-settings",302)
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "旧密码输入错误"
		//this.Redirect("/user-settings",302)
	}
}

func (this *UserSettingsController) UpdateUserEmail() {

}
