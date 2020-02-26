package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoEmail"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/cache"
	"github.com/astaxie/beego/utils/captcha"
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
	beego.Controller
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
	//beego.Info("user posted!")
	registerEmail := this.GetString("registerEmail")
	registerPassword := this.GetString("registerPassword")
	registerPasswordConfirm := this.GetString("registerPasswordConfirm")
	registerName := this.GetString("registerName")
	cptSuccess := cpt.VerifyReq(this.Ctx.Request)
	agreement, err := this.GetBool("agreement", false)
	if err != nil {
		beego.Error(err)
	}
	DB := MinoDatabase.GetDatabase()
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
	} else if !DB.Where("name = ?", registerName).First(&MinoDatabase.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "您输入的用户名已被占用！"
		return
	} else if !DB.Where("email = ?", registerEmail).First(&MinoDatabase.User{}).RecordNotFound() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "您输入的邮箱已被占用！"
		return
	} else {
		newUuid := uuid.NewV4()
		conf := MinoConfigure.GetConf()
		b := md5.Sum([]byte(registerPassword + conf.String("DatabaseSalt")))
		newUser := MinoDatabase.User{
			Name:           registerName,
			Email:          registerEmail,
			Password:       hex.EncodeToString(b[:]),
			UUID:           newUuid,
			IsAdmin:        false,
			EmailConfirmed: false,
		}
		beego.Info(newUser)
		DB.Create(&newUser)
		MinoMessage.Send("ADMIN", newUser.ID, "这是您的第一条消息")
		if MinoConfigure.SMTPEnabled {
			if err := MinoEmail.ConfirmRegister(newUser); err != nil {
				beego.Error(err)
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/reg",
					Detail: "即将跳转到注册页面",
					Title:  "邮件发送失败，请联系网站管理员！",
				}, &this.Controller)
			} else {
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "请前往您的邮箱进行验证！",
				}, &this.Controller)
			}
		} else {
			err := PterodactylAPI.PterodactylCreateUser(PterodactylAPI.ConfGetParams(), PterodactylAPI.PostPteUser{
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
				beego.Error("cant create pterodactyl user for " + newUser.Name)
				MinoMessage.Send("ADMIN", newUser.ID, "开通翼龙面板账户失败，请在用户设置界面开通后购买服务器！")
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册成功，但开户失败，请手动开通！",
				}, &this.Controller)
			} else {
				DB.Model(&newUser).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册成功！",
				}, &this.Controller)
				MinoMessage.Send("ADMIN", newUser.ID, "已为您开通翼龙面板账户，您可以购买服务器了！翼"+
					"龙面板的账户名为您的邮箱，密码为您的用户名，登录后请及时修改密码！")
			}
		}
	}
}

func (this *RegController) MailConfirm() {
	key := this.Ctx.Input.Param(":key")
	user, ok := MinoEmail.ConfirmKey(key)
	DB := MinoDatabase.GetDatabase()
	if ok {
		if MinoConfigure.SMTPEnabled {
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
				MinoMessage.Send("ADMIN", user.ID, "开通翼龙面板账户失败，请在用户设置界面开通后购买服务器！")
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功，但开户失败，请联系网站管理员！",
				}, &this.Controller)

			} else {
				MinoMessage.Send("ADMIN", user.ID, "已为您开通翼龙面板账户，您可以购买服务器了！翼"+
					"龙面板的账户名为您的邮箱，密码为您的用户名，登录后请及时修改密码！")
				DB.Model(&user).Update("pte_user_created", true)
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
					Detail: "即将跳转到登陆页面",
					Title:  "注册验证成功！",
				}, &this.Controller)
			}
		} else {
			DelayRedirect(DelayInfo{
				URL:    MinoConfigure.WebHostName + "/login",
				Detail: "即将跳转到登陆页面",
				Title:  "注册验证成功！",
			}, &this.Controller)
		}
	} else {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册验证失败！请重新验证！",
		}, &this.Controller)
	}
	this.TplName = "Delay.html"
}

func checkUserName(userName string) bool {
	const validChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"
	for i := 0; i < len(userName); i++ {
		//beego.Info(string(userName[i]))
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
	token := this.Ctx.Input.Query("_xsrf")
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
