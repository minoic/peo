package pterodactyl

import "github.com/minoic/peo/server/internal/config"

// ClientFromConf builds a client from the current settings. It is the only
// entry point the rest of the server uses, so a settings reload is picked up on
// the next call.
func ClientFromConf() *Client {
	settings := config.Snapshot()
	return NewClient(
		settings.String("PterodactylHostname"),
		settings.String("PterodactylToken"),
	)
}

// BridgeClientFromConf builds the Panel 2 PEO extension client with the same
// backend-only Application API token used by the core Panel API client.
func BridgeClientFromConf() *BridgeClient {
	settings := config.Snapshot()
	return NewBridgeClient(settings.String("PterodactylHostname"), settings.String("PterodactylToken"))
}
