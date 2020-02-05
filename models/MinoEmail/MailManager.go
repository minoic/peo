package MinoEmail

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/astaxie/beego"
	"github.com/xhit/go-simple-mail"
)

func sendConfirmMail(key MinoDatabase.RegConfirmKey) {
	conf := MinoConfigure.GetConf()
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := genRegConfirmMail(key.UserName, key.Key)
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(key.UserEmail).
		SetSubject(MinoConfigure.ConfGetWebName()+" 注册验证邮件").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		beego.Error(err)
	} else {
		beego.Info("mail sent successfully to: " + key.UserEmail)
	}
}

func SendCaptcha() (string, error) {
	return "", nil
}
