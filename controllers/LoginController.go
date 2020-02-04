package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type LoginController struct {
	beego.Controller
}

func (this *LoginController) Get() {
	this.TplName = "Login.html"
	this.Data["webHostName"] = MinoConfigure.ConfGetHostName()
	this.Data["webApplicationName"] = MinoConfigure.ConfGetWebName()
}

func (this *LoginController) Post() {
	this.TplName = "Login.html"
	DB := MinoDatabase.GetDatabase()
	defer DB.Close()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	loginRemember, err := this.GetBool("loginRemember")
	if err != nil {
		beego.Error(err)
	}
	var user MinoDatabase.User
	if !DB.Where("Email = ?", loginEOU).Or("Name = ?", loginEOU).First(&user).RecordNotFound() {
		if loginPass == user.Password {
			this.Data["loginReturnData"] = "logged in!"
			this.SetSession("LST", MinoSession.GeneToken(user.Name, loginRemember))
			this.SetSession("ID", user.ID)
		} else {
			this.Data["loginReturnData"] = "login failed!!"
		}
	}
	return
}
