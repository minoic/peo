package configure

import (
	"errors"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/conf"
	"github.com/smartwalle/alipay/v3"
	"github.com/spf13/viper"
	"os"
	"path"
)

var (
	AliClient *alipay.Client
	v         *viper.Viper
)

func init() {
	var err error
	if _, err := os.Stat("/conf/app.conf"); errors.Is(err, os.ErrNotExist) {
		file, _ := os.Create("/conf/app.conf")
		file.Write(conf.AppConf)
		file.Close()
		glgf.Error("未检测到配置文件，已生成默认，请重启应用程序")
		os.Exit(1)
	}
	if _, err := os.Stat("/conf/settings.toml"); errors.Is(err, os.ErrNotExist) {
		if _, err := os.Stat("/conf/settings.conf"); errors.Is(err, os.ErrNotExist) {
			glgf.Warn("找不到配置文件，正在生成 settings.toml")
			file, _ := os.Create("/conf/settings.toml")
			file.Write(conf.SettingsToml)
			file.Close()
		} else {
			glgf.Warn("找到旧版配置文件，正在转换 settings.conf->settings.toml")
			os.Rename("/conf/settings.conf", "/conf/settings.toml")
			ReloadConfig()
			Viper().Set("RedisHost", Viper().GetString("CacheRedisCONN"))
			if Viper().GetBool("WebSecure") {
				Viper().Set("WebHostName", path.Join("http://", Viper().GetString("WebHostName")))
			} else {
				Viper().Set("WebHostName", path.Join("https://", Viper().GetString("WebHostName")))
			}
			if Viper().GetBool("Serversecure") {
				Viper().Set("PterodactylHostname", path.Join("http://", Viper().GetString("Serverhostname")))
			} else {
				Viper().Set("PterodactylHostname", path.Join("https://", Viper().GetString("Serverhostname")))
			}
			Viper().Set("PterodactylToken", Viper().GetString("Serverpassword"))
			Viper().WriteConfig()
		}
	}
	ReloadConfig()
	if Viper().GetBool("AliPayEnabled") {
		AliClient, err = alipay.New(Viper().GetString("AliPayAppID"), Viper().GetString("AliPayPrivateKey"), true)
		if err != nil {
			panic(err)
		}
		err = AliClient.LoadAliPayPublicKey(Viper().GetString("AliPayPublicKey"))
		if err != nil {
			panic(err)
		}
	}
}

func ReloadConfig() {
	v = viper.New()
	v.SetConfigType("toml")
	v.SetConfigFile("conf/settings.toml")
	err := v.ReadInConfig()
	if err != nil {
		panic(err)
	}
}

func Viper() *viper.Viper {
	return v
}
