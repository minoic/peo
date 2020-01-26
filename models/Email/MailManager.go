package Email

import (
	"github.com/astaxie/beego"
	"github.com/xhit/go-simple-mail"
)

func TestMail() {
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := GenRegConfirmMail("haha")
	email := mail.NewMSG()
	email.SetFrom("MinoAdmin <admin@mail.nightgod.xyz>").
		AddTo("781482205@qq.com").
		SetSubject("New Go Email").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		beego.Error(err)
	} else {
		beego.Info("mail sent successfully")
	}
}
