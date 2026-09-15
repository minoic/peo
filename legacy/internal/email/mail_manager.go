package email

import (
	"fmt"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"github.com/xhit/go-simple-mail"
)

func sendConfirmMail(key database.RegConfirmKey) {
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		panic(err)
	}
	mailHtml, _ := genRegConfirmMail(key.UserName, key.KeyString)
	email := mail.NewMSG()
	email.SetFrom(configure.Viper().GetString("SMTPSendFrom")).
		AddTo(key.UserEmail).
		SetSubject(configure.Viper().GetString("WebApplicationName")+" 注册验证邮件").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		glgf.Error(err)
	} else {
		glgf.Info("mail sent successfully to: " + key.UserEmail)
	}
}

func SendCaptcha(receiver string) (string, error) {
	// glgf.Info(receiver)

	key := cryptoo.RandNumKey(6)
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		return "", err
	}
	mailHtml, _ := genForgetPasswordEmail(key)
	email := mail.NewMSG()
	email.SetFrom(configure.Viper().GetString("SMTPSendFrom")).
		AddTo(receiver).
		SetSubject(configure.Viper().GetString("WebApplicationName")+" 验证码").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		return "", nil
	}
	glgf.Info("mail sent successfully to: " + receiver)
	return key, nil
}

func SendAnyEmail(receiveAddr string, text ...string) error {
	smtpServer := getSTMPClient()
	smtpc, err := smtpServer.Connect()
	if err != nil {
		return err
	}
	mailHtml, _ := genAnyEmail(fmt.Sprint(text))
	email := mail.NewMSG()
	email.SetFrom(configure.Viper().GetString("SMTPSendFrom")).
		AddTo(receiveAddr).
		SetSubject(configure.Viper().GetString("WebApplicationName")+" 邮件通知系统").
		SetBody(mail.TextHTML, mailHtml)
	if err := email.Send(smtpc); err != nil {
		return err
	}
	glgf.Info("mail sent successfully to: " + receiveAddr)
	return nil
}
