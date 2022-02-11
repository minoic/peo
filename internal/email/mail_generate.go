package email

import (
	"github.com/matcornic/hermes/v2"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
)

func getProd() hermes.Hermes {
	return hermes.Hermes{
		Theme: new(hermes.Flat),
		Product: hermes.Product{
			Name:        configure.WebApplicationName + " Mail",
			Link:        configure.WebHostName,
			Logo:        configure.GetConf().String("SMTPLogo"),
			Copyright:   "Copyright 2021 MinoIC. All rights reserved.",
			TroubleText: "如果点击链接无效，请复制下列链接并在浏览器中打开：",
		},
	}
}

func genRegConfirmMail(userName string, key string) (string, string) {
	h := getProd()
	email := hermes.Email{
		Body: hermes.Body{
			Name: userName,
			Intros: []string{
				"欢迎来到 " + configure.WebApplicationName,
			},
			Actions: []hermes.Action{
				{
					Instructions: "确认您的注册：",
					Button: hermes.Button{
						Color: "#22BC66",
						Text:  "点击确认注册",
						Link:  configure.WebHostName + "/reg/confirm/" + key,
					},
				},
			},
			Outros: []string{
				"需要帮助请在网站内发送工单",
			},
		}}
	mailBody, err := h.GenerateHTML(email)
	if err != nil {
		panic(err)
	}
	mailText, err := h.GeneratePlainText(email)
	if err != nil {
		panic(err)
	}
	// glgf.Info(mailBody,mailText)
	return mailBody, mailText
}

func genForgetPasswordEmail(key string) (string, string) {
	h := getProd()
	email := hermes.Email{
		Body: hermes.Body{
			Intros: []string{
				configure.WebApplicationName + " 账户管理",
				"您正在修改密码，验证码为：" + key,
			},
			Outros: []string{
				"需要帮助请在网站内发送工单",
			},
		}}
	mailBody, err := h.GenerateHTML(email)
	if err != nil {
		glgf.Error(err)
		return "", ""
	}
	mailText, err := h.GeneratePlainText(email)
	if err != nil {
		glgf.Error(err)
		return "", ""
	}
	// glgf.Info(mailBody,mailText)
	return mailBody, mailText
}

func genAnyEmail(text string) (string, string) {
	h := getProd()
	email := hermes.Email{
		Body: hermes.Body{
			Intros: []string{
				text,
			},
			Outros: []string{
				"请不要回复本邮件，如果这不是您想收到的邮件，请忽略。",
			},
		},
	}
	mailBody, err := h.GenerateHTML(email)
	if err != nil {
		glgf.Error(err)
		return "", ""
	}
	mailText, err := h.GeneratePlainText(email)
	if err != nil {
		glgf.Error(err)
		return "", ""
	}
	return mailBody, mailText
}
