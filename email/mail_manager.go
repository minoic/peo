package email

import (
	"fmt"
	"github.com/MinoIC/MinoIC-PE/configure"
	"github.com/MinoIC/MinoIC-PE/cryptoo"
	"github.com/MinoIC/MinoIC-PE/database"
	"github.com/MinoIC/glgf"
	"github.com/xhit/go-simple-mail"
)

func sendConfirmMail(key database.RegConfirmKey) {
	conf := configure.GetConf()
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := genRegConfirmMail(key.UserName, key.KeyString)
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(key.UserEmail).
		SetSubject(configure.WebApplicationName+" 注册验证邮件").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		glgf.Error(err)
	} else {
		glgf.Info("mail sent successfully to: " + key.UserEmail)
	}
}

func SendCaptcha(receiver string) (string, error) {
	// glgf.Info(receiver)
	conf := configure.GetConf()
	key := cryptoo.RandNumKey(6)
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		return "", err
	}
	mailHtml, _ := genForgetPasswordEmail(key)
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(receiver).
		SetSubject(configure.WebApplicationName+" 验证码").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		return "", nil
	}
	glgf.Info("mail sent successfully to: " + receiver)
	return key, nil
}

func SendAnyEmail(receiveAddr string, text ...string) error {
	conf := configure.GetConf()
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		return err
	}
	mailHtml, _ := genAnyEmail(fmt.Sprint(text))
	email := mail.NewMSG()
	email.SetFrom(conf.String("SMTPSendFrom")).
		AddTo(receiveAddr).
		SetSubject(configure.WebApplicationName+" 邮件通知系统").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		return err
	}
	glgf.Info("mail sent successfully to: " + receiveAddr)
	return nil
}
