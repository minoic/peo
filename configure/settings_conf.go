package configure

import (
	"github.com/MinoIC/glgf"
	"github.com/astaxie/beego/config"
	"github.com/smartwalle/alipay/v3"
	"os"
)

var conf config.Configer

var (
	AliClient          *alipay.Client
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
	d, err := os.OpenFile("debug.log", os.O_APPEND|os.O_CREATE, os.ModePerm)
	if err != nil {
		panic(err)
	}
	e, err := os.OpenFile("error.log", os.O_APPEND|os.O_CREATE, os.ModePerm)
	if err != nil {
		panic(err)
	}
	glgf.Get().SetMode(glgf.BOTH).
		SetWriter(d).
		AddLevelWriter(glgf.ERR, e)
	e2, err := conf.Bool("AliPayEnabled")
	if err != nil {
		panic(err)
	}
	if e2 {
		AliClient, err = alipay.New(conf.String("AliPayAppID"), conf.String("AliPayPrivateKey"), true)
		if err != nil {
			panic(err)
		}
		err = AliClient.LoadAliPayPublicKey(conf.String("AliPayPublicKey"))
		if err != nil {
			panic(err)
		}
	}
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
