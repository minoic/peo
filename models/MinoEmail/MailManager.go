package MinoEmail

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"github.com/xhit/go-simple-mail"
)

func TestMail() {
	conf := models.GetConf()
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := genRegConfirmMail("haha")
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo("781482205@qq.com").
		SetSubject("New Go MinoEmail").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		beego.Error(err)
	} else {
		beego.Info("mail sent successfully")
	}
}
