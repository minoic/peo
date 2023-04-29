package conf

import (
	"embed"
)

//go:embed app.conf
var AppConf []byte

//go:embed settings.toml
var SettingsToml []byte

//go:embed locale
var Locale embed.FS
