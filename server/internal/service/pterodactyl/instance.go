package pterodactyl

import "github.com/minoic/peo/server/internal/config"

// ClientFromConf builds a client from the current settings. It is the only
// entry point the rest of the server uses, so a settings reload is picked up on
// the next call.
func ClientFromConf() *Client {
	return NewClient(
		config.String("PterodactylHostname"),
		config.String("PterodactylToken"),
	)
}
