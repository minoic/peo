package Email

import (
	"github.com/xhit/go-simple-mail"
	"time"
)

func getSTMPClient() *mail.SMTPServer {
	return &mail.SMTPServer{
		Authentication: mail.AuthPlain,
		Encryption:     mail.EncryptionTLS,
		Username:       "admin@mail.nightgod.xyz",
		Password:       "PublicAcPw90",
		ConnectTimeout: 10 * time.Second,
		SendTimeout:    20 * time.Second,
		Host:           "smtpdm-ap-southeast-1.aliyun.com",
		Port:           80,
		KeepAlive:      false,
	}
}
