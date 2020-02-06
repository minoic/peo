package MinoEmail

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"github.com/matcornic/hermes"
)

func getProd() hermes.Hermes {
	return hermes.Hermes{
		Theme: new(hermes.Flat),
		Product: hermes.Product{
			Name:        MinoConfigure.ConfGetWebName() + " Mail",
			Link:        MinoConfigure.ConfGetHostName(),
			Logo:        "https://img.ntmc.tech/images/2019/12/28/NX8HnUQpzzonZ77u.png",
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
				"欢迎来到 " + MinoConfigure.ConfGetWebName(),
			},
			Actions: []hermes.Action{
				{
					Instructions: "确认您的注册：",
					Button: hermes.Button{
						Color: "#22BC66",
						Text:  "点击确认注册",
						Link:  MinoConfigure.ConfGetHostName() + "/confirm/" + key,
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
	//beego.Info(mailBody,mailText)
	return mailBody, mailText
}

func genForgetPasswordEmail(key string) (string, string) {
	h := getProd()
	email := hermes.Email{
		Body: hermes.Body{
			Intros: []string{
				MinoConfigure.ConfGetWebName() + " 账户管理",
				"您正在修改密码，验证码为：" + key,
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
	//beego.Info(mailBody,mailText)
	return mailBody, mailText
}
