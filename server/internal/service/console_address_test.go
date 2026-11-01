package service

import (
	"testing"

	"github.com/minoic/peo/server/internal/service/pterodactyl"
)

func TestFormatServerAddress(t *testing.T) {
	tests := []struct {
		name       string
		allocation pterodactyl.Allocation
		want       string
	}{
		{name: "alias preferred", allocation: pterodactyl.Allocation{IP: "192.0.2.1", Alias: "play.example.net", Port: 25565}, want: "play.example.net:25565"},
		{name: "ip fallback", allocation: pterodactyl.Allocation{IP: "192.0.2.1", Port: 25565}, want: "192.0.2.1:25565"},
		{name: "ipv6", allocation: pterodactyl.Allocation{IP: "2001:db8::1", Port: 25565}, want: "[2001:db8::1]:25565"},
		{name: "missing address", allocation: pterodactyl.Allocation{Port: 25565}, want: ""},
		{name: "missing port", allocation: pterodactyl.Allocation{IP: "192.0.2.1"}, want: ""},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if got := formatServerAddress(test.allocation); got != test.want {
				t.Fatalf("formatServerAddress() = %q, want %q", got, test.want)
			}
		})
	}
}
