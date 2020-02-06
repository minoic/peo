package MinoConfigure

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/config"
)

var conf config.Configer

func init() {
	var err error
	conf, err = config.NewConfig("ini", "conf/settings.conf")
	if err != nil {
		panic("cant get settings.conf: " + err.Error())
	}
}

func GetConf() config.Configer {
	return conf
}

func ConfGetHostName() string {
	secure, err := conf.Bool("WebSecure")
	if err != nil {
		panic(err)
	}
	if secure {
		return "https://" + conf.String("WebHostName")
	}
	return "http://" + conf.String("WebHostName")
}

func ConfGetWebName() string {
	return conf.String("WebApplicationName")
}

func ConfGetSMTPEnabled() bool {
	enabled, err := conf.Bool("SMTPEnabled")
	if err != nil {
		beego.Error(err)
		return false
	}
	return enabled
}
