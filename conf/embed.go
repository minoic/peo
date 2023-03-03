package conf

import _ "embed"

//go:embed app.conf
var AppConf []byte

//go:embed settings.toml
var SettingsToml []byte
