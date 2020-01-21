package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
)

type PEAdminSettingsController struct {
	beego.Controller
}

func init() {
	DB := models.GetDatabase()
	var temp models.PEAdminSetting
	if DB.Where("Key = ?", "websiteName").First(&temp).RecordNotFound() {
		DB.Create(&models.PEAdminSetting{
			Model: gorm.Model{},
			Key:   "websiteName",
			Value: "DefaultName",
		})
	}
	temp = models.PEAdminSetting{}
	if DB.Where("Key = ?", "websiteHost").First(&temp).RecordNotFound() {
		DB.Create(&models.PEAdminSetting{
			Model: gorm.Model{},
			Key:   "websiteHost",
			Value: "localhost",
		})
	}
}
func (this *PEAdminSettingsController) Get() {
	this.TplName = "PEAdminSettings.html"
	sess := this.StartSession()
	if !models.SessionIslogged(sess) {
		this.Redirect("/login", 302)
	}
	userName := sess.Get("UN").(string)
	DB := models.GetDatabase()
	var user models.User
	if DB.Where("Name = ?", userName).First(&user).RecordNotFound() {
		beego.Info(userName + " user not found")
		this.Redirect("/", 302)
	}
	if !user.IsAdmin {
		beego.Warn(userName + " cant visit the PEAdminSettings")
		this.Redirect("/", 302)
	}
	var s models.PEAdminSetting
	if !DB.Where("Key = ?", "websiteName").First(&s).RecordNotFound() {
		this.Data["websiteNameDef"] = s.Value
		beego.Info("value:" + s.Value)
	}
	s = models.PEAdminSetting{}
	if !DB.Where("Key = ?", "websiteHost").First(&s).RecordNotFound() {
		this.Data["websiteHostDef"] = s.Value
		beego.Info("value:" + s.Value)
	}
}
func (this *PEAdminSettingsController) Post() {
	this.TplName = "PEAdminSettings.html"
	websiteName := this.GetString("websiteName")
	websiteHost := this.GetString("websiteHost")
	beego.Info(websiteHost)
	DB := models.GetDatabase()
	DB.Model(&models.PEAdminSetting{}).Where("Key = ?", "websiteName").Update(&models.PEAdminSetting{
		Model: gorm.Model{},
		Key:   "websiteName",
		Value: websiteName,
	})
	DB.Model(&models.PEAdminSetting{}).Where("Key = ?", "websiteHost").Update(&models.PEAdminSetting{
		Model: gorm.Model{},
		Key:   "websiteHost",
		Value: websiteHost,
	})
	this.Redirect("/pe-admin-settings.yml", 302)
}
