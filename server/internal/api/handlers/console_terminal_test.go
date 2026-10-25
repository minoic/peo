package handlers

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"golang.org/x/net/websocket"
)

func TestConsoleWebsocketRefreshesCredentialsAndKeepsTextEvents(t *testing.T) {
	refreshAuth := make(chan string, 1)
	sendLogs := make(chan string, 1)
	wings := httptest.NewServer(websocket.Handler(func(conn *websocket.Conn) {
		_ = websocket.Message.Send(conn, `{"event":"console output","args":["hello"]}`)
		_ = websocket.Message.Send(conn, `{"event":"token expiring","args":[]}`)
		var auth string
		if err := websocket.Message.Receive(conn, &auth); err != nil {
			return
		}
		refreshAuth <- auth
		for range 2 {
			_ = websocket.Message.Send(conn, `{"event":"auth success","args":["never forward a token"]}`)
			var logs string
			if err := websocket.Message.Receive(conn, &logs); err == nil {
				sendLogs <- logs
			}
		}
	}))
	defer wings.Close()

	panel := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if !strings.HasSuffix(r.URL.Path, "/servers/server-uuid/websocket") {
			t.Errorf("unexpected bridge request path %q", r.URL.Path)
		}
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"data":{"socket":"ws://node.invalid/api/servers/server-uuid/ws","token":"refreshed-secret","expires_in":600}}`))
	}))
	defer panel.Close()
	bridge := pterodactyl.NewBridgeClient(panel.URL, "application-token")

	upstreamURL := "ws" + strings.TrimPrefix(wings.URL, "http")
	upstream, err := websocket.Dial(upstreamURL, "", "http://localhost")
	if err != nil {
		t.Fatalf("dial mock Wings: %v", err)
	}
	defer upstream.Close()

	proxy := httptest.NewServer(websocket.Handler(func(client *websocket.Conn) {
		relayPanelFrames(context.Background(), bridge, "server-uuid", upstream, client)
	}))
	defer proxy.Close()
	browserURL := "ws" + strings.TrimPrefix(proxy.URL, "http")
	browser, err := websocket.Dial(browserURL, "", "http://localhost")
	if err != nil {
		t.Fatalf("dial console proxy: %v", err)
	}
	defer browser.Close()

	var output string
	if err := websocket.Message.Receive(browser, &output); err != nil {
		t.Fatalf("receive console output: %v", err)
	}
	if output != `{"event":"console output","args":["hello"]}` {
		t.Fatalf("console output frame = %q", output)
	}
	select {
	case message := <-refreshAuth:
		var frame struct {
			Event string   `json:"event"`
			Args  []string `json:"args"`
		}
		if err := json.Unmarshal([]byte(message), &frame); err != nil || frame.Event != "auth" || len(frame.Args) != 1 || frame.Args[0] != "refreshed-secret" {
			t.Fatalf("refreshed auth frame = %q, err=%v", message, err)
		}
	case <-time.After(3 * time.Second):
		t.Fatal("bridge did not provide refreshed Wings credentials")
	}
	select {
	case message := <-sendLogs:
		if message != `{"event":"send logs","args":[null]}` {
			t.Fatalf("internal log subscription = %q", message)
		}
	case <-time.After(3 * time.Second):
		t.Fatal("Go proxy did not request initial logs after auth success")
	}
	select {
	case message := <-sendLogs:
		t.Fatalf("Go proxy requested historical logs again after reauthentication: %q", message)
	case <-time.After(150 * time.Millisecond):
	}

	_ = browser.SetDeadline(time.Now().Add(150 * time.Millisecond))
	var leaked string
	if err := websocket.Message.Receive(browser, &leaked); err == nil {
		t.Fatalf("credential-bearing auth event reached browser: %q", leaked)
	}
}

func TestConsoleWebsocketClosesOnUpstreamJWTErrorWithoutForwardingDetails(t *testing.T) {
	wings := httptest.NewServer(websocket.Handler(func(conn *websocket.Conn) {
		_ = websocket.Message.Send(conn, `{"event":"jwt error","args":["jwt: missing connect permission"]}`)
	}))
	defer wings.Close()

	upstreamURL := "ws" + strings.TrimPrefix(wings.URL, "http")
	upstream, err := websocket.Dial(upstreamURL, "", "http://localhost")
	if err != nil {
		t.Fatalf("dial mock Wings: %v", err)
	}
	defer upstream.Close()

	bridge := pterodactyl.NewBridgeClient("http://panel.invalid", "application-token")
	proxy := httptest.NewServer(websocket.Handler(func(client *websocket.Conn) {
		relayPanelFrames(context.Background(), bridge, "server-uuid", upstream, client)
	}))
	defer proxy.Close()

	browserURL := "ws" + strings.TrimPrefix(proxy.URL, "http")
	browser, err := websocket.Dial(browserURL, "", "http://localhost")
	if err != nil {
		t.Fatalf("dial console proxy: %v", err)
	}
	defer browser.Close()
	_ = browser.SetDeadline(time.Now().Add(2 * time.Second))
	var frame string
	if err := websocket.Message.Receive(browser, &frame); err == nil {
		t.Fatalf("upstream JWT error details reached browser: %q", frame)
	}
}

func TestTerminalFrameFiltersRejectCredentialEventsAndKeepOnlyReadCommands(t *testing.T) {
	for _, input := range []string{
		`{"event":"auth","args":["secret"]}`,
		`{"event":"send command","args":["op"]}`,
		`{"event":"unknown","args":[]}`,
	} {
		if _, ok := filterClientTerminalFrame(input); ok {
			t.Errorf("client event %s should have been rejected", input)
		}
	}
	for _, input := range []string{
		`{"event":"send logs","args":[null]}`,
		`{"event":"send stats","args":[null]}`,
	} {
		got, ok := filterClientTerminalFrame(input)
		if !ok || got != input {
			t.Errorf("filterClientTerminalFrame(%s) = (%q, %v)", input, got, ok)
		}
	}
}
