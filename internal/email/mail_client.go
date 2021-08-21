package email

import (
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/xhit/go-simple-mail"
	"time"
)

func getSTMPClient() *mail.SMTPServer {
	conf := configure.GetConf()
	temp := conf.String("SMTPEncryption")
	encryption := mail.EncryptionTLS
	if temp == "SSL" {
		encryption = mail.EncryptionSSL
	} else if temp != "TLS" && temp != "SSL" {
		glgf.Error("wrong SMTP encryption")
	}
	port, err := conf.Int("SMTPPort")
	if err != nil {
		glgf.Error("cant get SMTPPort")
	}
	return &mail.SMTPServer{
		// Authentication: mail.AuthPlain,
		Encryption:     encryption,
		Username:       conf.String("SMTPUsername"),
		Password:       conf.String("SMTPUserPassword"),
		ConnectTimeout: 10 * time.Second,
		SendTimeout:    20 * time.Second,
		Host:           conf.String("SMTPHost"),
		Port:           port,
		KeepAlive:      false,
	}
}
