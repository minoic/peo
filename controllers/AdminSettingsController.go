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
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetHostName() + "/login",
			Detail: "正在跳转到登录",
			Title:  "您还没有登录",
		}, &this.Controller)
	}
	userName := sess.Get("UN").(string)
	DB := models.GetDatabase()
	var user models.User
	if DB.Where("Name = ?", userName).First(&user).RecordNotFound() {
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetWebName(),
			Detail: "正在跳转到主页",
			Title:  "用户名未找到",
		}, &this.Controller)
	}
	if !user.IsAdmin {
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetWebName(),
			Detail: "正在跳转到主页",
			Title:  "用户没有访问权限",
		}, &this.Controller)
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
	DelayRedirect(DelayInfo{
		URL:    models.ConfGetWebName() + "/pe-admin-settings",
		Detail: "正在跳转回设置页",
		Title:  "更新设置成功",
	}, &this.Controller)
}

//todo: use settings.conf instead of database
