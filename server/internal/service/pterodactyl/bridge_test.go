package pterodactyl

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"net/url"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/minoic/peo/server/internal/config"
	"golang.org/x/net/websocket"
)

func TestMain(m *testing.M) {
	if err := config.Init(); err != nil {
		panic(err)
	}
	os.Exit(m.Run())
}

func TestBridgeDecodesPanelExtensionDTOs(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		switch r.URL.Path {
		case bridgePath + "servers/server-uuid":
			_, _ = io.WriteString(w, `{"data":{"uuid":"server-uuid","identifier":"abcdef01","name":"Survival","status":null,"suspended":false,"installing":false,"docker_image":"ghcr.io/example/java:21","limits":{"memory":2048,"disk":4096,"cpu":100},"feature_limits":{"backups":5},"egg":{"id":3,"name":"Minecraft","docker_images":{"ghcr.io/example/java:21":"Java 21"}},"startup":{"command":"java -jar server.jar","docker_image":"ghcr.io/example/java:21","variables":[{"env_variable":"SERVER_JARFILE","name":"Server Jar","description":"Jar file","default_value":"server.jar","server_value":"paper.jar","is_editable":true,"rules":"required|string"}]}}}`)
		case bridgePath + "servers/server-uuid/files/list":
			_, _ = io.WriteString(w, `{"data":[{"name":"server.properties","mode":"0644","mode_bits":"0644","size":128,"is_file":true,"is_symlink":false,"is_editable":true,"mimetype":"text/plain","created_at":"2026-10-17T00:00:00Z","modified_at":"2026-10-17T00:00:00Z"}]}`)
		case bridgePath + "servers/server-uuid/files/contents":
			_, _ = io.WriteString(w, `{"data":{"content":"motd=hello"}}`)
		case bridgePath + "servers/server-uuid/backups":
			_, _ = io.WriteString(w, `{"data":[{"uuid":"backup-uuid","name":"before-upgrade","bytes":512,"completed":true,"locked":true,"created_at":"2026-10-17T00:00:00Z","checksum":"sha256:abc","status":"completed","progress":100}],"meta":{"pagination":{"current_page":1,"last_page":1,"per_page":50,"total":1},"backup_count":1}}`)
		default:
			http.NotFound(w, r)
		}
	}))
	defer server.Close()
	bridge := NewBridgeClient(server.URL, "panel-token")

	serverDTO, err := bridge.Server(context.Background(), "server-uuid")
	if err != nil {
		t.Fatalf("Server() error = %v", err)
	}
	if serverDTO.DockerImage != "ghcr.io/example/java:21" || serverDTO.Startup.DockerImage != serverDTO.DockerImage || serverDTO.Startup.Variables[0].Value != "paper.jar" {
		t.Fatalf("Server() startup DTO = %#v", serverDTO.Startup)
	}
	if got := serverDTO.Egg.DockerImages["ghcr.io/example/java:21"]; got != "Java 21" {
		t.Fatalf("Egg.DockerImages image-to-label mapping = %q", got)
	}

	files, err := bridge.FileList(context.Background(), "server-uuid", "/")
	if err != nil || len(files) != 1 || files[0].Name != "server.properties" || !files[0].IsEditable {
		t.Fatalf("FileList() = %#v, %v", files, err)
	}
	content, err := bridge.FileContents(context.Background(), "server-uuid", "/server.properties")
	if err != nil || content != "motd=hello" {
		t.Fatalf("FileContents() = %q, %v", content, err)
	}
	backups, err := bridge.Backups(context.Background(), "server-uuid")
	if err != nil || len(backups) != 1 || !backups[0].Completed || !backups[0].Locked || backups[0].Status != "completed" {
		t.Fatalf("Backups() = %#v, %v", backups, err)
	}
}

func TestBridgeFileListInfersEditableTextFromPanelFileObjects(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != bridgePath+"servers/server-uuid/files/list" {
			http.NotFound(w, r)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, `{"data":[
			{"name":"server.properties","is_file":true,"is_symlink":false,"mimetype":"text/plain"},
			{"name":"pterodactyl.yml","is_file":true,"is_symlink":false,"mimetype":"application/octet-stream"},
			{"name":"config/","is_file":false,"is_symlink":false,"mimetype":"inode/directory"},
			{"name":"world.jar","is_file":true,"is_symlink":false,"mimetype":"application/java-archive"},
			{"name":"misreported.jar","is_file":true,"is_symlink":false,"mimetype":"text/plain"},
			{"name":"fake-text.cfg","is_file":true,"is_symlink":false,"mimetype":"application/java-archive"},
			{"name":"texture.png","is_file":true,"is_symlink":false,"mimetype":"image/png"},
			{"name":"settings.custom","is_file":true,"is_symlink":false,"mimetype":"application/x-unknown"},
			{"name":"README","is_file":true,"is_symlink":false,"mimetype":"text/plain"},
			{"name":"payload.dat","is_file":true,"is_symlink":false,"mimetype":"application/octet-stream"},
			{"name":"disabled.yml","is_file":true,"is_symlink":false,"is_editable":false,"mimetype":"text/plain"}
		]}`)
	}))
	defer server.Close()

	files, err := NewBridgeClient(server.URL, "panel-token").FileList(context.Background(), "server-uuid", "/")
	if err != nil {
		t.Fatalf("FileList() error = %v", err)
	}
	want := map[string]bool{
		"server.properties": true,
		"pterodactyl.yml":   true,
		"config/":           false,
		"world.jar":         false,
		"misreported.jar":   false,
		"fake-text.cfg":     false,
		"texture.png":       false,
		"settings.custom":   false,
		"README":            true,
		"payload.dat":       false,
		"disabled.yml":      false,
	}
	for _, file := range files {
		if expected, ok := want[file.Name]; !ok || file.IsEditable != expected {
			t.Errorf("FileList()[%q].IsEditable = %v, want %v", file.Name, file.IsEditable, expected)
		}
		delete(want, file.Name)
	}
	if len(want) != 0 {
		t.Errorf("FileList() missing files: %v", want)
	}
}

func TestOpenTrustedStreamStreamsWithoutPanelCredentials(t *testing.T) {
	var authorization string
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authorization = r.Header.Get("Authorization")
		w.Header().Set("Content-Type", "application/octet-stream")
		w.WriteHeader(http.StatusOK)
		_, _ = io.WriteString(w, "stream-body")
	}))
	defer server.Close()

	bridge := NewBridgeClient(server.URL, "panel-secret")
	parsed, _ := url.Parse(server.URL)
	response, err := bridge.OpenTrustedStream(context.Background(), BridgeURL{
		URL:  server.URL + "/files?signature=signed",
		Host: parsed.Hostname(),
	}, http.MethodGet, "", nil, 0, false, false)
	if err != nil {
		t.Fatalf("OpenTrustedStream() error = %v", err)
	}
	defer response.Body.Close()
	body, err := io.ReadAll(response.Body)
	if err != nil {
		t.Fatalf("read stream: %v", err)
	}
	if string(body) != "stream-body" {
		t.Fatalf("stream body = %q", body)
	}
	if authorization != "" {
		t.Fatalf("signed stream unexpectedly received Authorization: %q", authorization)
	}
}

func TestOpenTrustedStreamDoesNotFollowRedirects(t *testing.T) {
	var redirected bool
	target := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		redirected = true
		w.WriteHeader(http.StatusOK)
	}))
	defer target.Close()
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, target.URL+"/collect", http.StatusFound)
	}))
	defer server.Close()

	bridge := NewBridgeClient(server.URL, "panel-secret")
	parsed, _ := url.Parse(server.URL)
	_, err := bridge.OpenTrustedStream(context.Background(), BridgeURL{
		URL:  server.URL + "/files?signature=signed",
		Host: parsed.Hostname(),
	}, http.MethodGet, "", nil, 0, false, false)
	if err == nil {
		t.Fatal("OpenTrustedStream() accepted a redirect")
	}
	if redirected {
		t.Fatal("OpenTrustedStream() followed a redirect to an untrusted host")
	}
}

func TestNormalizeOriginRequiresAnExactOrigin(t *testing.T) {
	for _, test := range []struct {
		input string
		want  string
	}{
		{"HTTPS://Storage.Example:443", "https://storage.example"},
		{"https://storage.example:9443", "https://storage.example:9443"},
		{"https://storage.example/path", ""},
		{"https://user@storage.example", ""},
	} {
		if got := normalizeOrigin(test.input); got != test.want {
			t.Errorf("normalizeOrigin(%q) = %q, want %q", test.input, got, test.want)
		}
	}
}

func TestBridgeRejectsRedirectResponseAsFailure(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Location", "https://example.invalid/")
		w.WriteHeader(http.StatusFound)
	}))
	defer server.Close()

	err := NewBridgeClient(server.URL, "panel-secret").Power(context.Background(), "server-uuid", "start")
	if err == nil {
		t.Fatal("Power() treated a redirect response as success")
	}
}

func TestBridgeErrorsDoNotExposeUpstreamBodies(t *testing.T) {
	for _, status := range []int{http.StatusUnauthorized, http.StatusForbidden, http.StatusInternalServerError} {
		t.Run(strconv.Itoa(status), func(t *testing.T) {
			server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
				w.WriteHeader(status)
				_, _ = io.WriteString(w, `{"error":"Bearer hidden-token https://s3.example.test/file?X-Amz-Signature=secret"}`)
			}))
			defer server.Close()

			err := NewBridgeClient(server.URL, "panel-secret").Power(context.Background(), "server-uuid", "start")
			if err == nil {
				t.Fatal("Power() unexpectedly succeeded")
			}
			for _, secret := range []string{"hidden-token", "X-Amz-Signature", "s3.example.test"} {
				if strings.Contains(err.Error(), secret) {
					t.Fatalf("error leaked upstream detail %q: %v", secret, err)
				}
			}
		})
	}
}

func TestDialSocketAcceptsCanonicalWebsocketURLWithoutQuery(t *testing.T) {
	var rawQuery string
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/api/servers/server-uuid/ws" {
			rawQuery = r.URL.RawQuery
			websocket.Handler(func(conn *websocket.Conn) { _ = conn.Close() }).ServeHTTP(w, r)
			return
		}
		http.NotFound(w, r)
	}))
	defer server.Close()
	parsed, err := url.Parse(server.URL)
	if err != nil {
		t.Fatal(err)
	}
	port := parsed.Port()
	if port == "" {
		t.Fatal("test server URL has no port")
	}
	bridge := NewBridgeClient(server.URL, "panel-secret")
	socket := BridgeSocket{Socket: "ws://" + parsed.Host + "/api/servers/server-uuid/ws", Token: "wings-jwt", ExpiresIn: 600}
	conn, err := bridge.DialSocket(context.Background(), socket, "server-uuid")
	if err != nil {
		t.Fatalf("DialSocket() rejected canonical query-free socket (port %s): %v", port, err)
	}
	_ = conn.Close()
	if rawQuery != "" {
		t.Fatalf("websocket URL unexpectedly had query %q", rawQuery)
	}
}

func TestTrustedTargetUsesAdvertisedNodeAndBackupOrigins(t *testing.T) {
	var panel *httptest.Server
	panel = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		switch {
		case r.URL.Path == "/api/application/nodes":
			_, _ = io.WriteString(w, `{"data":[{"attributes":{"fqdn":"node.example.test","daemon_listen":8080}}],"meta":{"pagination":{"total_pages":1}}}`)
		case r.URL.Path == bridgePath+"capabilities":
			_, _ = io.WriteString(w, `{"data":{"extension":{"id":"peo-bridge","version":"1.0.0"},"protocol_version":1,"panel_version":"2.0.0-beta.2","capabilities":["files","backups","startup"],"trusted_stream_hosts":["s3.example.test","bucket.s3.example.test"],"trusted_stream_origins":["https://s3.example.test:9443","https://bucket.s3.example.test:9443"]}}`)
		default:
			http.NotFound(w, r)
		}
	}))
	defer panel.Close()
	previous := config.Settings()
	if err := config.LoadSettings(map[string]any{"PterodactylHostname": panel.URL, "PterodactylToken": "test-token"}); err != nil {
		t.Fatalf("configure test panel: %v", err)
	}
	t.Cleanup(func() {
		if err := config.LoadSettings(previous); err != nil {
			t.Errorf("restore config: %v", err)
		}
	})

	bridge := NewBridgeClient(panel.URL, "extension-token")
	for _, test := range []struct {
		name    string
		raw     string
		host    string
		backup  bool
		wantErr bool
	}{
		{name: "node daemon port", raw: "https://node.example.test:8080/download?token=signed", host: "node.example.test"},
		{name: "path-style custom s3 port", raw: "https://s3.example.test:9443/bucket/file?signature=signed", host: "s3.example.test", backup: true},
		{name: "virtual-host custom s3 port", raw: "https://bucket.s3.example.test:9443/file?signature=signed", host: "bucket.s3.example.test", backup: true},
		{name: "unadvertised s3 port", raw: "https://s3.example.test:9000/bucket/file?signature=signed", host: "s3.example.test", backup: true, wantErr: true},
	} {
		t.Run(test.name, func(t *testing.T) {
			_, err := bridge.TrustedTarget(context.Background(), test.raw, test.host, test.backup, false)
			if (err != nil) != test.wantErr {
				t.Fatalf("TrustedTarget() error = %v, wantErr %v", err, test.wantErr)
			}
		})
	}
}

func TestCapabilitiesDecodeTrustedStorageOrigins(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		_, _ = io.WriteString(w, `{"data":{"extension":{"id":"peo-bridge","version":"1.0.0"},"protocol_version":1,"panel_version":"2.0.0-beta.2","capabilities":["servers","resources","power","command","websocket","files","backups","startup"],"trusted_stream_hosts":["s3.example.test"],"trusted_stream_origins":["https://s3.example.test:9443"]}}`)
	}))
	defer server.Close()
	caps, err := NewBridgeClient(server.URL, "panel-token").Capabilities(context.Background())
	if err != nil {
		t.Fatalf("Capabilities() error = %v", err)
	}
	if caps.Extension.ID != "peo-bridge" || caps.ProtocolVersion != 1 || len(caps.TrustedStreamOrigins) != 1 || caps.TrustedStreamOrigins[0] != "https://s3.example.test:9443" {
		t.Fatalf("Capabilities() = %#v", caps)
	}
	if _, err := json.Marshal(caps); err != nil {
		t.Fatalf("marshal capabilities DTO: %v", err)
	}
}

func TestCheckCapabilitiesProbesReadAndWriteScopes(t *testing.T) {
	var getSeen, postSeen bool
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != bridgePath+"capabilities" {
			http.NotFound(w, r)
			return
		}
		switch r.Method {
		case http.MethodGet:
			getSeen = true
		case http.MethodPost:
			postSeen = true
		default:
			http.Error(w, "unexpected method", http.StatusMethodNotAllowed)
			return
		}
		_, _ = io.WriteString(w, `{"data":{"extension":{"id":"peo-bridge","version":"1.0.0"},"protocol_version":1,"panel_version":"2.0.0-beta.2","capabilities":["servers","resources","power","command","websocket","files","backups","startup"],"trusted_stream_hosts":[],"trusted_stream_origins":[]}}`)
	}))
	defer server.Close()
	if err := NewBridgeClient(server.URL, "read-write-scope-test").CheckCapabilities(context.Background()); err != nil {
		t.Fatalf("CheckCapabilities() error = %v", err)
	}
	if !getSeen || !postSeen {
		t.Fatalf("CheckCapabilities() requests: GET=%v POST=%v", getSeen, postSeen)
	}
}

func TestCheckCapabilitiesReportsMissingWriteScopeWithoutResponseBody(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			w.WriteHeader(http.StatusForbidden)
			_, _ = io.WriteString(w, `{"error":"missing write scope; leaked-token"}`)
			return
		}
		_, _ = io.WriteString(w, `{"data":{"extension":{"id":"peo-bridge","version":"1.0.0"},"protocol_version":1,"panel_version":"2.0.0-beta.2","capabilities":["servers","resources","power","command","websocket","files","backups","startup"],"trusted_stream_hosts":[],"trusted_stream_origins":[]}}`)
	}))
	defer server.Close()
	client := NewBridgeClient(server.URL, "write-scope-test")
	err := client.CheckCapabilities(context.Background())
	if err == nil {
		t.Fatal("CheckCapabilities() accepted a token without write scope")
	}
	if strings.Contains(err.Error(), "leaked-token") || strings.Contains(err.Error(), "missing write scope") {
		t.Fatalf("CheckCapabilities() leaked upstream response: %v", err)
	}
	var bridgeErr *BridgeError
	if !errors.As(err, &bridgeErr) || bridgeErr.StatusCode != http.StatusForbidden {
		t.Fatalf("CheckCapabilities() error = %T %v, want 403 BridgeError", err, err)
	}
}
