package pterodactyl

import (
	"github.com/minoic/peo/internal/configure"
)

var confInstance *Client

func ClientFromConf() *Client {
	if confInstance != nil {
		return confInstance
	}
	PterodactylHostname := configure.Viper().GetString("PterodactylHostname")
	ret := NewClient(PterodactylHostname, configure.Viper().GetString("ServerPassword"))
	confInstance = ret
	return ret
}
