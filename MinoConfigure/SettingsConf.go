package MinoConfigure

import (
	"github.com/astaxie/beego/config"
)

var conf config.Configer

var (
	RechargeMode       bool
	SqlTablePrefix     string
	TotalDiscount      bool
	UseGormCache       bool
	SMTPEnabled        bool
	WebApplicationName string
	WebHostName        string
	AdminAddress       string
)

func init() {
	var err error
	conf, err = config.NewConfig("ini", "conf/settings.conf")
	if err != nil {
		panic("cant get settings.conf: " + err.Error())
	}
	ReloadConfig()
}

func ReloadConfig() {
	var err error
	RechargeMode, err = conf.Bool("RechargeMode")
	if err != nil {
		panic(err)
	}
	SMTPEnabled, err = conf.Bool("SMTPEnabled")
	if err != nil {
		panic(err)
	}
	TotalDiscount, err = conf.Bool("TotalDiscount")
	if err != nil {
		panic(err)
	}
	UseGormCache, err = conf.Bool("UseGormCache")
	if err != nil {
		panic(err)
	}
	WebApplicationName = conf.String("WebApplicationName")
	AdminAddress = conf.String("WebAdminAddress")
	SqlTablePrefix = conf.String("SqlTablePrefix")
	secure, err := conf.Bool("WebSecure")
	if err != nil {
		panic(err)
	}
	if secure {
		WebHostName = "https://" + conf.String("WebHostName")
	} else {
		WebHostName = "http://" + conf.String("WebHostName")
	}
}

func GetConf() config.Configer {
	return conf
}
