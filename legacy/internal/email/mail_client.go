package email

import (
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/xhit/go-simple-mail"
	"time"
)

func getSTMPClient() *mail.SMTPServer {

	temp := configure.Viper().GetString("SMTPEncryption")
	encryption := mail.EncryptionTLS
	if temp == "SSL" {
		encryption = mail.EncryptionSSL
	} else if temp != "TLS" && temp != "SSL" {
		glgf.Error("wrong SMTP encryption")
	}
	port := configure.Viper().GetInt("SMTPPort")
	return &mail.SMTPServer{
		// Authentication: mail.AuthPlain,
		Encryption:     encryption,
		Username:       configure.Viper().GetString("SMTPUsername"),
		Password:       configure.Viper().GetString("SMTPUserPassword"),
		ConnectTimeout: 10 * time.Second,
		SendTimeout:    20 * time.Second,
		Host:           configure.Viper().GetString("SMTPHost"),
		Port:           port,
		KeepAlive:      false,
	}
}
