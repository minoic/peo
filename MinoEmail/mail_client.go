package MinoEmail

import (
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/glgf"
	"github.com/xhit/go-simple-mail"
	"time"
)

func getSTMPClient() *mail.SMTPServer {
	conf := MinoConfigure.GetConf()
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
