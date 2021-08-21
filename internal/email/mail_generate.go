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
			Logo:        "data:image/png;base64,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",
			Copyright:   "Copyright © 2020 Mino. All rights reserved.",
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
				"需要帮助请发邮件至 cytusd@outlook.com",
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
				"需要帮助请发邮件至 cytusd@outlook.com",
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
