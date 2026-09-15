// Package email sends the transactional messages of the site over SMTP.
package email

import (
	"errors"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
	mail "github.com/xhit/go-simple-mail"
)

// smtpClient builds the SMTP server description from the configuration.
func smtpClient() *mail.SMTPServer {
	encryption := mail.EncryptionTLS
	switch config.String("SMTPEncryption") {
	case "SSL":
		encryption = mail.EncryptionSSL
	case "TLS":
	default:
		glgf.Error("email: unknown SMTPEncryption value: " + config.String("SMTPEncryption"))
	}
	return &mail.SMTPServer{
		Encryption:     encryption,
		Username:       config.String("SMTPUsername"),
		Password:       config.String("SMTPUserPassword"),
		ConnectTimeout: 10 * time.Second,
		SendTimeout:    20 * time.Second,
		Host:           config.String("SMTPHost"),
		Port:           config.Int("SMTPPort"),
		KeepAlive:      false,
	}
}

// send delivers one message. It is the single place that decides whether mail is
// enabled at all, so a disabled SMTP configuration never opens a connection.
//
// The legacy sendConfirmMail panicked when the connection failed, which took the
// whole request down; every failure here is returned to the caller instead.
func send(to, subject, html, text string) error {
	if !config.Bool("SMTPEnabled") {
		return errors.New("email: SMTP is disabled in the settings")
	}
	server := smtpClient()
	conn, err := server.Connect()
	if err != nil {
		return err
	}
	defer func() { _ = conn.Close() }()

	msg := mail.NewMSG()
	msg.SetFrom(config.String("SMTPSendFrom")).
		AddTo(to).
		SetSubject(config.String("WebApplicationName") + " " + subject)
	if html != "" {
		msg.SetBody(mail.TextHTML, html)
	} else {
		msg.SetBody(mail.TextPlain, text)
	}
	if err := msg.Send(conn); err != nil {
		return err
	}
	glgf.Info("email: sent '" + subject + "' to " + to)
	return nil
}

// SendCaptcha mails the one-time code that the caller generated. Unlike the
// legacy SendCaptcha, which generated the code itself and swallowed send errors,
// this returns the failure so the caller can tell the user the mail did not go
// out.
func SendCaptcha(to, code string) error {
	html, text := codeBody(config.String("WebApplicationName")+" account",
		"Your verification code is: ", code)
	if html == "" {
		html, text = plainFallback("Verification code: " + code)
	}
	return send(to, "verification code", html, text)
}

// SendAnyEmail sends a free-form notification assembled from the fragments the
// caller passes. The legacy version used fmt.Sprint on a slice, which wrapped
// every notification in square brackets; the fragments are joined instead.
func SendAnyEmail(to string, fragments ...string) error {
	body := joinText(fragments...)
	html, text := noticeBody(body)
	return send(to, "notification", html, text)
}

// SendConfirmRegister mails the registration confirmation link.
//
// The legacy code path that called this was unreachable - nothing invoked
// email.ConfirmRegister - so registrations were confirmed by hand. It is wired
// up again here.
func SendConfirmRegister(to, userName, key string) error {
	html, text := confirmRegistrationBody(userName, key)
	if html == "" {
		html, text = plainFallback(config.String("WebHostName") + "/confirm-email/" + key)
	}
	return send(to, "registration confirmation", html, text)
}
