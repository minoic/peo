package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/client/cache"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/beego/v2/server/web/captcha"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	uuid "github.com/satori/go.uuid"
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
}

func (this *RegController) Get() {
	this.TplName = "Register.html"
	handleNavbar(&this.Controller)
}

func (this *RegController) Post() {
	this.TplName = "Register.html"
	handleNavbar(&this.Controller)
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	// glgf.Info("user posted!")
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
		this.Data["hasErrorText"] = "验证码输入错误，请重试！"
		return
	} else if !agreement {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "您必须同意我们的用户协议才能注册！"
		return
	} else if registerPassword != registerPasswordConfirm {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "两次密码输入不一致，请检查！"
		return
	} else if !checkUserName(registerName) {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "用户名只能包含字母、数字、下划线！"
		return
	} else if !DB.Where("name = ?", registerName).First(&database.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "您输入的用户名已被占用！"
		return
	} else if !DB.Where("email = ?", registerEmail).First(&database.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "您输入的邮箱已被占用！"
		return
	} else {
		newUuid := uuid.NewV4()

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
		message.Send("ADMIN", newUser.ID, "这是您的第一条消息")
		if newUser.IsAdmin {
			message.Send("ADMIN", newUser.ID, "您是第一个注册的账号，已被设置为管理员")
		}
		if configure.Viper().GetBool("SMTPEnabled") {
			message.Send("Admin", newUser.ID, "您已成功注册账号，请前往邮箱确认注册，确认时会自动帮您创建翼龙面板用户，或请您在用户设置页面手动创建")
			if err := email.ConfirmRegister(newUser); err != nil {
				glgf.Error(err)
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/reg",
					Detail: "即将跳转到注册页面",
					Title:  "邮件发送失败，请联系网站管理员！",
				}, &this.Controller)
			} else {
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "请前往您的邮箱进行验证！",
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
				glgf.Error("cant create pterodactyl user for " + newUser.Name)
				message.Send("ADMIN", newUser.ID, "开通翼龙面板账户失败，请在用户设置界面开通后购买服务器！")
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册成功，但开户失败，请手动开通！",
				}, &this.Controller)
			} else {
				DB.Model(&newUser).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册成功！",
				}, &this.Controller)
				message.Send("ADMIN", newUser.ID, "已为您开通翼龙面板账户，您可以购买服务器了！翼"+
					"龙面板的账户名为您的邮箱，密码为您的用户名，登录后请及时修改密码！")
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
				message.Send("ADMIN", user.ID, "开通翼龙面板账户失败，请在用户设置界面开通后购买服务器！")
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功，但开户失败，请联系网站管理员！",
				}, &this.Controller)

			} else {
				message.Send("ADMIN", user.ID, "已为您开通翼龙面板账户，您可以购买服务器了！翼"+
					"龙面板的账户名为您的邮箱，密码为您的用户名，登录后请及时修改密码！")
				DB.Model(&user).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    configure.Viper().GetString("WebHostName") + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功！",
				}, &this.Controller)
			}
		} else {
			DelayRedirect(DelayInfo{
				URL:    configure.Viper().GetString("WebHostName") + "/login",
				Detail: "即将跳转到登陆页面",
				Title:  "注册验证成功！",
			}, &this.Controller)
		}
	} else {
		DelayRedirect(DelayInfo{
			URL:    configure.Viper().GetString("WebHostName") + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册验证失败！请重新验证！",
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

func (this *RegController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.GetString("_xsrf")
	if token == "" {
		token = this.Ctx.Input.Query("_xsrf")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Xsrftoken")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Csrftoken")
	}
	if token == "" {
		return false
	}
	if this.XSRFToken() != token {
		return false
	}
	return true
}
