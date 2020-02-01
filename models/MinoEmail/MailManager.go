package MinoEmail

import (
	"git.ntmc.tech/root/MinoIC-PE/models"
	"github.com/astaxie/beego"
	"github.com/xhit/go-simple-mail"
)

func SendConfirmMail(key models.RegConfirmKey) {
	conf := models.GetConf()
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := genRegConfirmMail(key.UserName, key.Key)
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(key.UserEmail).
		SetSubject(models.ConfGetWebName()+" 注册验证邮件").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		beego.Error(err)
	} else {
		beego.Info("mail sent successfully to: " + key.UserEmail)
	}
}
