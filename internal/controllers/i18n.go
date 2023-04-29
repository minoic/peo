package controllers

import (
	"github.com/beego/i18n"
	"github.com/minoic/peo/internal/configure"
)

func tr(input string) string {
	return i18n.Tr(configure.Viper().GetString("Language"), input)
}
