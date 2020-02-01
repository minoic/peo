package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models"
	"github.com/astaxie/beego"
)

type LoginController struct {
	beego.Controller
}

func (this *LoginController) Get() {
	this.TplName = "Login.html"
	this.Data["webHostName"] = models.ConfGetHostName()
	this.Data["webApplicationName"] = models.ConfGetWebName()
}

func (this *LoginController) Post() {
	this.TplName = "Login.html"
	DB := models.GetDatabase()
	defer DB.Close()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	var user models.User
	if !DB.Where("Email = ?", loginEOU).Or("Name = ?", loginEOU).First(&user).RecordNotFound() {
		if loginPass == user.Password {
			this.Data["loginReturnData"] = "logged in!"
			this.SetSession("LST", models.GeneToken(user.Name))
			this.SetSession("ID", user.ID)
		} else {
			this.Data["loginReturnData"] = "login failed!!"
		}
	}
	return
}
