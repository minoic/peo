package MinoEmail

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoKey"
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
		SetSubject(MinoConfigure.WebApplicationName+" 注册验证邮件").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		beego.Error(err)
	} else {
		beego.Info("mail sent successfully to: " + key.UserEmail)
	}
}

func SendCaptcha(receiver string) (string, error) {
	//beego.Info(receiver)
	conf := MinoConfigure.GetConf()
	key := MinoKey.RandNumKey(6)
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		return "", err
	}
	mailHtml, _ := genForgetPasswordEmail(key)
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(receiver).
		SetSubject(MinoConfigure.WebApplicationName+" 验证码").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		return "", nil
	} else {
		beego.Info("mail sent successfully to: " + receiver)
	}
	return key, nil
}
