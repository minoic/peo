package configure

import (
	"errors"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/conf"
	"github.com/smartwalle/alipay/v3"
	"github.com/spf13/viper"
	"os"
	"path"
	"strings"
)

var (
	AliClient *alipay.Client
	v         *viper.Viper
)

func init() {
	if _, err := os.Stat("conf/app.conf"); errors.Is(err, os.ErrNotExist) {
		file, _ := os.Create("conf/app.conf")
		_, err := file.Write(conf.AppConf)
		if err != nil {
			panic(err)
		}
		file.Close()
		glgf.Error("No configuration file detected, default generated, please restart the application")
		os.Exit(1)
	}
	if _, err := os.Stat("conf/settings.toml"); errors.Is(err, os.ErrNotExist) {
		if _, err := os.Stat("conf/settings.conf"); errors.Is(err, os.ErrNotExist) {
			glgf.Warn("Config file not found, generating settings.toml")
			file, _ := os.Create("conf/settings.toml")
			_, err := file.Write(conf.SettingsToml)
			if err != nil {
				panic(err)
			}
			file.Close()
		} else {
			glgf.Warn("Legacy config file found, converting settings.conf -> settings.toml")
			err := os.Rename("conf/settings.conf", "conf/settings.toml")
			if err != nil {
				panic(err)
			}
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
			err = Viper().WriteConfig()
			if err != nil {
				panic(err)
			}
		}
	}
	initLocalefile()
	ReloadConfig()
	if Viper().GetBool("AliPayEnabled") {
		AliClient, _ = alipay.New(Viper().GetString("AliPayAppID"), Viper().GetString("AliPayPrivateKey"), true)
		err := AliClient.LoadAliPayPublicKey(Viper().GetString("AliPayPublicKey"))
		if err != nil {
			panic(err)
		}
	}
}

func initLocalefile() {
	entries, err := conf.Locale.ReadDir("locale")
	if err != nil {
		panic(err)
	}
	os.Mkdir("conf/locale", os.ModePerm)
	for i := range entries {
		if _, err := os.Stat("conf/locale/" + entries[i].Name()); errors.Is(err, os.ErrNotExist) {
			glgf.Debugf("Writing locale file %s to folder", entries[i].Name())
			file, err := os.Create("conf/locale/" + entries[i].Name())
			if err != nil {
				panic(err)
			}
			readFile, err := conf.Locale.ReadFile("locale/" + entries[i].Name())
			if err != nil {
				panic(err)
			}
			_, err = file.Write(readFile)
			if err != nil {
				panic(err)
			}
		}
	}
	locales, err := os.ReadDir("conf/locale")
	if err != nil {
		panic(err)
	}
	for i := range locales {
		if strings.HasSuffix(locales[i].Name(), ".ini") {
			err := i18n.SetMessage(strings.TrimSuffix(locales[i].Name(), ".ini"), "conf/locale/"+locales[i].Name())
			if err != nil {
				panic(err)
			}
			glgf.Debugf("Added locale file %s to system", locales[i].Name())
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
	v.Set("WebHostName", strings.TrimRight(v.GetString("WebHostName"), "/"))
	v.Set("PterodactylHostname", strings.TrimRight(v.GetString("PterodactylHostname"), "/"))
	if v.GetInt("RedisDB") == 0 {
		v.Set("RedisDB", 0)
	}
	err = v.WriteConfig()
	if err != nil {
		panic(err)
	}
}

func Viper() *viper.Viper {
	return v
}
