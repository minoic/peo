package pterodactyl

import (
	"github.com/minoic/peo/internal/configure"
)

func ClientFromConf() *Client {
	return NewClient(configure.Viper().GetString("PterodactylHostname"), configure.Viper().GetString("PterodactylToken"))
}
