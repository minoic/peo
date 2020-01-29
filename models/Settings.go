package models

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/config"
)

func GetConf() config.Configer {
	conf, err := config.NewConfig("ini", "conf/settings.conf")
	if err != nil {
		panic("cant get settings.conf: " + err.Error())
		return nil
	}
	return conf
}

func confGetParams() ParamsData {
	conf := GetConf()
	sec, err := conf.Bool("Serversecure")
	if err != nil {
		beego.Error(err.Error())
	}
	data := ParamsData{
		Serverhostname: conf.String("Serverhostname"),
		Serversecure:   sec,
		Serverpassword: conf.String("Serverpassword"),
	}
	return data
}

func ConfGetHostName() string {
	conf := GetConf()
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
	conf := GetConf()
	return conf.String("WebApplicationName")
}
