package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/client/cache"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/beego/v2/server/web/captcha"
	"github.com/beego/i18n"
	"github.com/gofrs/uuid/v5"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"strings"
)

var cpt *captcha.Captcha

func init() {
	// use beego cache system store the captcha data
	store := cache.NewMemoryCache()
	cpt = captcha.NewWithFilter("/captcha/", store)
	cpt.StdHeight = 40
	cpt.StdWidth = 100
	cpt.ChallengeNums = 4
}

type RegController struct {
	web.Controller
	i18n.Locale
}

func (this *RegController) Prepare() {
	this.TplName = "Register.html"
	handleNavbar(&this.Controller)
	this.Data["lang"] = configure.Viper().GetString("Language")
}

func (this *RegController) Get() {}

func (this *RegController) Post() {
	registerEmail := this.GetString("registerEmail")
	registerPassword := this.GetString("registerPassword")
	registerPasswordConfirm := this.GetString("registerPasswordConfirm")
	registerName := this.GetString("registerName")
	cptSuccess := cpt.VerifyReq(this.Ctx.Request)
	agreement, err := this.GetBool("agreement", false)
	if err != nil {
		glgf.Error(err)
	}
	var userCount int
	DB := database.Mysql()
	DB.Model(&database.User{}).Count(&userCount)
	if !cptSuccess {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_captcha_error")
		return
	} else if !agreement {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_terms_error")
		return
	} else if registerPassword != registerPasswordConfirm {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_confirm_error")
		return
	} else if !checkUserName(registerName) {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_username_error")
		return
	} else if !DB.Where("name = ?", registerName).First(&database.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_username_used")
		return
	} else if !DB.Where("email = ?", registerEmail).First(&database.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.register_email_used")
		return
	} else {
		newUuid, _ := uuid.NewV4()
		b := md5.Sum([]byte(registerPassword + configure.Viper().GetString("DatabaseSalt")))
		newUser := database.User{
			Name:           registerName,
			Email:          registerEmail,
			Password:       hex.EncodeToString(b[:]),
			UUID:           newUuid,
			IsAdmin:        false,
			EmailConfirmed: false,
		}
		if userCount == 0 {
			newUser.IsAdmin = true
		}
		glgf.Info(newUser)
		DB.Create(&newUser)
		message.Send("ADMIN", newUser.ID, tr("auth.first_message"))
		if newUser.IsAdmin {
			message.Send("ADMIN", newUser.ID, tr("auth.admin_tips"))
		}
		if configure.Viper().GetBool("SMTPEnabled") {
			message.Send("Admin", newUser.ID, tr("auth.pterodactyl_account_tips"))
			if err := email.ConfirmRegister(newUser); err != nil {
				glgf.Error(err)
				DelayRedirect(DelayInfo{
					URL:    "/reg",
					Detail: tr("auth.jump_to_reg"),
					Title:  tr("auth.email_failed"),
				}, &this.Controller)
			} else {
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.email_verify"),
				}, &this.Controller)
			}
		} else {
			err := pterodactyl.ClientFromConf().CreateUser(pterodactyl.PostPteUser{
				ExternalId: newUser.Name,
				Username:   newUser.Name,
				Email:      newUser.Email,
				Language:   "zh",
				RootAdmin:  newUser.IsAdmin,
				Password:   newUser.Name,
				FirstName:  newUser.Name,
				LastName:   "_",
			})
			if err != nil {
				glgf.Error("cant create pterodactyl user for "+newUser.Name, err)
				message.Send("ADMIN", newUser.ID, tr("auth.pterodactyl_account_failed"))
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.register_success2"),
				}, &this.Controller)
			} else {
				DB.Model(&newUser).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.register_success"),
				}, &this.Controller)
				message.Send("ADMIN", newUser.ID, tr("auth.pterodactyl_account_success_tips"))
			}
		}
	}
}

func (this *RegController) MailConfirm() {
	key := this.Ctx.Input.Param(":key")
	user, ok := email.ConfirmKey(key)
	DB := database.Mysql()
	if ok {
		if configure.Viper().GetBool("SMTPEnabled") {
			err := pterodactyl.ClientFromConf().CreateUser(pterodactyl.PostPteUser{
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
				glgf.Error("cant create pterodactyl user for " + user.Name)
				message.Send("ADMIN", user.ID, tr("auth.pterodactyl_account_failed"))
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.register_success2"),
				}, &this.Controller)

			} else {
				message.Send("ADMIN", user.ID, tr("auth.pterodactyl_account_success_tips"))
				DB.Model(&user).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.register_success"),
				}, &this.Controller)
			}
		} else {
			DelayRedirect(DelayInfo{
				URL:    "/login",
				Detail: tr("auth.jump_to_login"),
				Title:  tr("auth.verify_success"),
			}, &this.Controller)
		}
	} else {
		DelayRedirect(DelayInfo{
			URL:    "/login",
			Detail: tr("auth.jump_to_login"),
			Title:  tr("auth.verify_failed"),
		}, &this.Controller)
	}
	this.TplName = "Delay.html"
}

func checkUserName(userName string) bool {
	const validChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"
	for i := 0; i < len(userName); i++ {
		// glgf.Info(string(userName[i]))
		if !strings.ContainsAny(validChar, string(userName[i])) {
			return false
		}
	}
	return true
}
