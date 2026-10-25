package pterodactyl

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"path"
	"strconv"
	"strings"
	"sync"
	"time"

	"golang.org/x/net/websocket"
)

const bridgePath = "/api/application/extensions/peo-bridge/v1/"

// BridgeClient speaks only the versioned, allowlisted PEO extension API.
type BridgeClient struct {
	base   string
	token  string
	client *http.Client
}

var capabilityCache = struct {
	sync.Mutex
	validUntil map[string]time.Time
}{validUntil: make(map[string]time.Time)}

func NewBridgeClient(base, token string) *BridgeClient {
	return &BridgeClient{base: strings.TrimRight(strings.TrimSpace(base), "/") + bridgePath, token: token,
		client: &http.Client{Timeout: 30 * time.Second, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}}
}

func (c *BridgeClient) PanelOrigin() string {
	u, err := url.Parse(strings.TrimSuffix(c.base, bridgePath))
	if err != nil {
		return ""
	}
	return u.Scheme + "://" + u.Host
}

// BridgeError contains only a status code and a fixed message. It intentionally
// omits upstream response bodies, which may contain signed URLs or credentials.
type BridgeError struct {
	StatusCode int
	Message    string
}

func (e *BridgeError) Error() string { return e.Message }

type BridgeProtocolError struct{ Message string }

func (e *BridgeProtocolError) Error() string { return e.Message }

func (c *BridgeClient) request(ctx context.Context, method, path string, body any, out any) error {
	if c.base == bridgePath || c.token == "" {
		return errors.New("pterodactyl bridge is not configured")
	}
	u, err := url.Parse(c.base + path)
	if err != nil || u.Scheme == "" || u.Host == "" {
		return errors.New("pterodactyl bridge has an invalid base URL")
	}
	var reader io.Reader
	if body != nil {
		buf := new(bytes.Buffer)
		if err := json.NewEncoder(buf).Encode(body); err != nil {
			return errors.New("cannot encode bridge request")
		}
		reader = buf
	}
	req, err := http.NewRequestWithContext(ctx, method, u.String(), reader)
	if err != nil {
		return errors.New("cannot create bridge request")
	}
	req.Header.Set("Authorization", "Bearer "+c.token)
	req.Header.Set("Accept", "application/json")
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := c.client.Do(req)
	if err != nil {
		return errors.New("Panel extension request failed")
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		msg := "Panel extension request failed"
		switch resp.StatusCode {
		case http.StatusUnauthorized:
			msg = "Panel API token is invalid"
		case http.StatusForbidden:
			msg = "Panel API token lacks permissions required by the extension"
		case http.StatusNotFound:
			msg = "Panel extension is missing or disabled"
		case http.StatusNotImplemented:
			msg = "Panel extension does not support this operation"
		}
		return &BridgeError{StatusCode: resp.StatusCode, Message: msg}
	}
	if out == nil {
		_, _ = io.Copy(io.Discard, resp.Body)
		return nil
	}
	var envelope struct {
		Data json.RawMessage `json:"data"`
	}
	if err := json.NewDecoder(io.LimitReader(resp.Body, 8<<20)).Decode(&envelope); err != nil {
		return errors.New("Panel extension returned an invalid response")
	}
	if len(envelope.Data) == 0 || string(envelope.Data) == "null" {
		return errors.New("Panel extension returned an empty response")
	}
	if err := json.Unmarshal(envelope.Data, out); err != nil {
		return errors.New("Panel extension response did not match the supported protocol")
	}
	return nil
}

func (c *BridgeClient) get(ctx context.Context, path string, out any) error {
	return c.request(ctx, http.MethodGet, path, nil, out)
}
func (c *BridgeClient) post(ctx context.Context, path string, body, out any) error {
	return c.request(ctx, http.MethodPost, path, body, out)
}
func (c *BridgeClient) put(ctx context.Context, path string, body, out any) error {
	return c.request(ctx, http.MethodPut, path, body, out)
}

type BridgeCapabilities struct {
	Extension struct {
		ID      string `json:"id"`
		Version string `json:"version"`
	} `json:"extension"`
	ProtocolVersion      int      `json:"protocol_version"`
	PanelVersion         string   `json:"panel_version"`
	Capabilities         []string `json:"capabilities"`
	TrustedStreamHosts   []string `json:"trusted_stream_hosts"`
	TrustedStreamOrigins []string `json:"trusted_stream_origins"`
}

func (c *BridgeClient) CheckCapabilities(ctx context.Context) error {
	key := c.base + ":" + fmt.Sprintf("%x", sha256.Sum256([]byte(c.token)))
	capabilityCache.Lock()
	if time.Now().Before(capabilityCache.validUntil[key]) {
		capabilityCache.Unlock()
		return nil
	}
	capabilityCache.Unlock()

	readCaps, err := c.Capabilities(ctx)
	if err != nil {
		return err
	}
	if err := validateCapabilities(readCaps); err != nil {
		return err
	}
	var writeCaps BridgeCapabilities
	if err := c.post(ctx, "capabilities", map[string]any{}, &writeCaps); err != nil {
		return err
	}
	if err := validateCapabilities(writeCaps); err != nil {
		return err
	}
	if readCaps.Extension.Version != writeCaps.Extension.Version || readCaps.PanelVersion != writeCaps.PanelVersion {
		return &BridgeProtocolError{Message: "Panel PEO extension capability checks returned inconsistent versions"}
	}

	capabilityCache.Lock()
	for cachedKey, until := range capabilityCache.validUntil {
		if !time.Now().Before(until) {
			delete(capabilityCache.validUntil, cachedKey)
		}
	}
	if len(capabilityCache.validUntil) >= 64 {
		capabilityCache.validUntil = make(map[string]time.Time)
	}
	capabilityCache.validUntil[key] = time.Now().Add(30 * time.Second)
	capabilityCache.Unlock()
	return nil
}

func validateCapabilities(caps BridgeCapabilities) error {
	if caps.Extension.ID != "peo-bridge" || caps.ProtocolVersion != 1 {
		return &BridgeProtocolError{Message: "Panel PEO extension protocol is incompatible"}
	}
	required := []string{"servers", "resources", "power", "command", "websocket", "files", "backups", "startup"}
	have := make(map[string]bool, len(caps.Capabilities))
	for _, capability := range caps.Capabilities {
		have[capability] = true
	}
	for _, capability := range required {
		if !have[capability] {
			return &BridgeProtocolError{Message: "Panel PEO extension is missing required capabilities"}
		}
	}
	return nil
}

func (c *BridgeClient) Capabilities(ctx context.Context) (BridgeCapabilities, error) {
	var v BridgeCapabilities
	err := c.get(ctx, "capabilities", &v)
	return v, err
}

type BridgeVariable struct {
	Key          string `json:"env_variable"`
	Name         string `json:"name"`
	Description  string `json:"description"`
	DefaultValue string `json:"default_value"`
	Value        string `json:"server_value"`
	Editable     bool   `json:"is_editable"`
	Rules        string `json:"rules"`
}
type BridgeServer struct {
	UUID        string `json:"uuid"`
	Identifier  string `json:"identifier"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Status      string `json:"status"`
	Suspended   bool   `json:"suspended"`
	Installing  bool   `json:"installing"`
	Limits      struct {
		Memory  int    `json:"memory"`
		Disk    int    `json:"disk"`
		CPU     int    `json:"cpu"`
		IO      int    `json:"io"`
		Swap    int    `json:"swap"`
		Threads string `json:"threads"`
	} `json:"limits"`
	FeatureLimits struct {
		Databases   int `json:"databases"`
		Allocations int `json:"allocations"`
		Backups     int `json:"backups"`
	} `json:"feature_limits"`
	Egg struct {
		ID           int               `json:"id"`
		Name         string            `json:"name"`
		DockerImages map[string]string `json:"docker_images"`
	} `json:"egg"`
	Startup struct {
		Command     string           `json:"command"`
		DockerImage string           `json:"docker_image"`
		Variables   []BridgeVariable `json:"variables"`
	} `json:"startup"`
	DockerImage string `json:"docker_image"`
}

func (c *BridgeClient) Server(ctx context.Context, uuid string) (BridgeServer, error) {
	var v BridgeServer
	err := c.get(ctx, "servers/"+url.PathEscape(uuid), &v)
	return v, err
}

type BridgeResources struct {
	CurrentState string `json:"current_state"`
	IsSuspended  bool   `json:"is_suspended"`
	Resources    struct {
		MemoryBytes    int64   `json:"memory_bytes"`
		CPUAbsolute    float64 `json:"cpu_absolute"`
		DiskBytes      int64   `json:"disk_bytes"`
		NetworkRXBytes int64   `json:"network_rx_bytes"`
		NetworkTXBytes int64   `json:"network_tx_bytes"`
		Uptime         int64   `json:"uptime"`
	} `json:"resources"`
}

func (c *BridgeClient) Resources(ctx context.Context, uuid string) (BridgeResources, error) {
	var v BridgeResources
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/resources", &v)
	return v, err
}
func (c *BridgeClient) Power(ctx context.Context, uuid, signal string) error {
	return c.post(ctx, "servers/"+url.PathEscape(uuid)+"/power", map[string]string{"signal": signal}, nil)
}
func (c *BridgeClient) Command(ctx context.Context, uuid, command string) error {
	return c.post(ctx, "servers/"+url.PathEscape(uuid)+"/command", map[string]string{"command": command}, nil)
}

type BridgeSocket struct {
	Socket    string `json:"socket"`
	Token     string `json:"token"`
	ExpiresIn int    `json:"expires_in"`
}

func (c *BridgeClient) Socket(ctx context.Context, uuid string) (BridgeSocket, error) {
	var v BridgeSocket
	err := c.post(ctx, "servers/"+url.PathEscape(uuid)+"/websocket", map[string]string{}, &v)
	if err == nil && (v.Socket == "" || v.Token == "" || v.ExpiresIn <= 0) {
		err = fmt.Errorf("Panel extension returned invalid websocket credentials")
	}
	return v, err
}

// DialSocket validates the extension-provided socket host and opens a backend
// connection. The Wings token is sent only in the WebSocket auth event.
func (c *BridgeClient) DialSocket(ctx context.Context, socket BridgeSocket, serverUUID string) (*websocket.Conn, error) {
	target := BridgeURL{URL: socket.Socket}
	u, err := url.Parse(socket.Socket)
	if err != nil {
		return nil, errors.New("Panel returned an invalid websocket address")
	}
	if u.Path != "/api/servers/"+serverUUID+"/ws" || u.RawQuery != "" {
		return nil, errors.New("Panel returned a websocket address for an unexpected server")
	}
	target.Host = u.Hostname()
	u, err = c.TrustedTarget(ctx, target.URL, target.Host, false, true)
	if err != nil {
		return nil, err
	}
	origin, err := url.Parse(c.PanelOrigin())
	if err != nil || origin.Host == "" {
		return nil, errors.New("Panel origin is invalid")
	}
	conn, err := (&websocket.Config{
		Location: u,
		Origin:   origin,
		Version:  websocket.ProtocolVersionHybi13,
	}).DialContext(ctx)
	if err != nil {
		return nil, errors.New("cannot connect to the server websocket")
	}
	return conn, nil
}

type BridgeFile struct {
	Name       string `json:"name"`
	Mode       string `json:"mode"`
	ModeBits   string `json:"mode_bits"`
	Size       int64  `json:"size"`
	IsFile     bool   `json:"is_file"`
	IsSymlink  bool   `json:"is_symlink"`
	IsEditable bool   `json:"is_editable"`
	MimeType   string `json:"mimetype"`
	CreatedAt  string `json:"created_at"`
	ModifiedAt string `json:"modified_at"`
}

// UnmarshalJSON keeps the public bool contract while distinguishing a missing
// upstream hint from an explicit false value.
func (f *BridgeFile) UnmarshalJSON(data []byte) error {
	type wire BridgeFile
	var decoded struct {
		wire
		IsEditable *bool `json:"is_editable"`
	}
	if err := json.Unmarshal(data, &decoded); err != nil {
		return err
	}
	*f = BridgeFile(decoded.wire)
	if decoded.IsEditable != nil {
		f.IsEditable = *decoded.IsEditable
	}
	if decoded.IsEditable != nil && !*decoded.IsEditable {
		f.IsEditable = false
	} else {
		f.IsEditable = isTextBridgeFile(*f)
	}
	return nil
}

var editableTextExtensions = map[string]bool{
	".cfg": true, ".conf": true, ".config": true, ".env": true,
	".ini": true, ".json": true, ".log": true, ".mcfunction": true, ".mcmeta": true,
	".properties": true, ".snbt": true, ".sh": true, ".toml": true, ".txt": true,
	".xml": true, ".yaml": true, ".yml": true,
}

var binaryFileExtensions = map[string]bool{
	".7z": true, ".bmp": true, ".class": true, ".dll": true, ".exe": true,
	".gif": true, ".gz": true, ".ico": true, ".jar": true, ".jpeg": true,
	".jpg": true, ".mp3": true, ".mp4": true, ".pdf": true, ".png": true,
	".rar": true, ".so": true, ".tar": true, ".webp": true, ".woff": true,
	".woff2": true, ".zip": true,
}

func isTextBridgeFile(file BridgeFile) bool {
	if !file.IsFile || file.IsSymlink {
		return false
	}
	mime := strings.ToLower(strings.TrimSpace(strings.SplitN(file.MimeType, ";", 2)[0]))
	ext := strings.ToLower(path.Ext(file.Name))
	if binaryFileExtensions[ext] || strings.HasPrefix(mime, "application/zip") ||
		strings.HasPrefix(mime, "application/x-rar") || strings.HasPrefix(mime, "application/x-7z") ||
		strings.HasPrefix(mime, "application/gzip") || strings.HasPrefix(mime, "application/x-tar") ||
		mime == "application/java-archive" || mime == "application/x-msdownload" || mime == "application/pdf" ||
		strings.HasPrefix(mime, "image/") && mime != "image/svg+xml" {
		return false
	}
	// Panel 2 commonly reports application/octet-stream for ordinary files.
	if mime == "application/octet-stream" {
		return editableTextExtensions[ext]
	}
	if strings.HasPrefix(mime, "text/") || mime == "application/json" || mime == "application/xml" || mime == "image/svg+xml" {
		return true
	}
	if strings.HasPrefix(mime, "audio/") || strings.HasPrefix(mime, "video/") || strings.HasPrefix(mime, "font/") {
		return false
	}
	return editableTextExtensions[ext]
}

type BridgeBackup struct {
	UUID      string `json:"uuid"`
	Name      string `json:"name"`
	Bytes     int64  `json:"bytes"`
	Completed bool   `json:"completed"`
	Locked    bool   `json:"locked"`
	CreatedAt string `json:"created_at"`
	Checksum  string `json:"checksum"`
	Status    string `json:"status"`
	Progress  int    `json:"progress"`
}
type BridgeURL struct {
	URL           string `json:"url"`
	Filename      string `json:"filename"`
	ContentType   string `json:"content_type"`
	ContentLength int64  `json:"content_length"`
	Host          string `json:"host"`
}

func (c *BridgeClient) FileList(ctx context.Context, uuid, directory string) ([]BridgeFile, error) {
	var v []BridgeFile
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/files/list?directory="+url.QueryEscape(directory), &v)
	return v, err
}
func (c *BridgeClient) FileContents(ctx context.Context, uuid, file string) (string, error) {
	var v struct {
		Content string `json:"content"`
	}
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/files/contents?file="+url.QueryEscape(file), &v)
	return v.Content, err
}
func (c *BridgeClient) FileURL(ctx context.Context, uuid, action, file string) (BridgeURL, error) {
	var v BridgeURL
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/files/"+action+"?file="+url.QueryEscape(file), &v)
	return v, err
}
func (c *BridgeClient) UploadURL(ctx context.Context, uuid, directory string) (BridgeURL, error) {
	var v BridgeURL
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/files/upload?directory="+url.QueryEscape(directory), &v)
	return v, err
}
func (c *BridgeClient) FileAction(ctx context.Context, uuid, action string, body any) error {
	method := http.MethodPost
	upstreamAction := action
	if action == "rename" {
		method = http.MethodPut
	}
	if action == "mkdir" {
		upstreamAction = "create-folder"
	}
	return c.request(ctx, method, "servers/"+url.PathEscape(uuid)+"/files/"+upstreamAction, body, nil)
}
func (c *BridgeClient) WriteFile(ctx context.Context, uuid, file, content string) error {
	return c.request(ctx, http.MethodPost, "servers/"+url.PathEscape(uuid)+"/files/write?file="+url.QueryEscape(file), map[string]string{"content": content}, nil)
}
func (c *BridgeClient) Backups(ctx context.Context, uuid string) ([]BridgeBackup, error) {
	var v []BridgeBackup
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/backups", &v)
	return v, err
}
func (c *BridgeClient) CreateBackup(ctx context.Context, uuid, name string) (BridgeBackup, error) {
	var v BridgeBackup
	err := c.post(ctx, "servers/"+url.PathEscape(uuid)+"/backups", map[string]string{"name": name}, &v)
	return v, err
}
func (c *BridgeClient) BackupURL(ctx context.Context, uuid, backupID string) (BridgeURL, error) {
	var v BridgeURL
	err := c.get(ctx, "servers/"+url.PathEscape(uuid)+"/backups/"+url.PathEscape(backupID)+"/download", &v)
	return v, err
}
func (c *BridgeClient) BackupAction(ctx context.Context, uuid, backupID, action string, body any) error {
	return c.post(ctx, "servers/"+url.PathEscape(uuid)+"/backups/"+url.PathEscape(backupID)+"/"+action, body, nil)
}
func (c *BridgeClient) DeleteBackup(ctx context.Context, uuid, backupID string) error {
	return c.request(ctx, http.MethodDelete, "servers/"+url.PathEscape(uuid)+"/backups/"+url.PathEscape(backupID), nil, nil)
}

// TrustedTarget validates extension-returned transfer addresses against panel
// node data and (for backups) the storage hosts advertised by capabilities.
func (c *BridgeClient) TrustedTarget(ctx context.Context, raw, declaredHost string, backup, websocket bool) (*url.URL, error) {
	u, err := url.Parse(raw)
	if err != nil || u.Hostname() == "" || u.User != nil || u.Fragment != "" || (!websocket && u.RawQuery == "") {
		return nil, errors.New("Panel returned an invalid transfer address")
	}
	if !strings.EqualFold(strings.TrimSuffix(u.Hostname(), "."), strings.TrimSuffix(declaredHost, ".")) {
		return nil, errors.New("Panel transfer address host did not match its signed metadata")
	}
	wantScheme := map[string]bool{"https": true, "http": true}
	if websocket {
		wantScheme = map[string]bool{"wss": true, "ws": true}
	}
	if !wantScheme[strings.ToLower(u.Scheme)] {
		return nil, errors.New("Panel returned an unsupported transfer scheme")
	}
	trusted := map[string]bool{}
	panelURL, _ := url.Parse(strings.TrimSuffix(c.base, bridgePath))
	if panelURL != nil {
		trusted[strings.ToLower(panelURL.Hostname())] = true
	}
	nodes, nodeErr := ClientFromConf().GetAllNodes(ctx)
	if nodeErr == nil {
		for _, node := range nodes {
			trusted[strings.ToLower(strings.TrimSuffix(node.FQDN, "."))] = true
		}
	}
	trustedBackupOrigins := map[string]bool{}
	if backup {
		caps, capErr := c.Capabilities(ctx)
		if capErr != nil {
			return nil, errors.New("cannot validate Panel backup storage host")
		}
		for _, host := range caps.TrustedStreamHosts {
			if host != "" {
				trusted[strings.ToLower(strings.TrimSuffix(host, "."))] = true
			}
		}
		for _, origin := range caps.TrustedStreamOrigins {
			trustedBackupOrigins[normalizeOrigin(origin)] = true
		}
	}
	host := strings.ToLower(strings.TrimSuffix(u.Hostname(), "."))
	if !trusted[host] {
		return nil, errors.New("Panel returned a transfer host outside the trusted Panel and storage hosts")
	}
	port := u.Port()
	if port != "" {
		allowedPort := port == "443" || port == "80"
		if nodes != nil {
			for _, node := range nodes {
				if strings.EqualFold(strings.TrimSuffix(node.FQDN, "."), host) && strconv.Itoa(node.DaemonListen) == port {
					allowedPort = true
					break
				}
			}
		}
		if panelURL != nil && host == strings.ToLower(panelURL.Hostname()) && panelURL.Port() == port {
			allowedPort = true
		}
		if backup && trustedBackupOrigins[normalizeOrigin(u.Scheme+"://"+u.Host)] {
			allowedPort = true
		}
		if !allowedPort {
			return nil, errors.New("Panel returned an untrusted transfer port")
		}
	}
	return u, nil
}

func normalizeOrigin(raw string) string {
	u, err := url.Parse(raw)
	if err != nil || u.Scheme == "" || u.Host == "" || u.User != nil || u.Path != "" || u.RawQuery != "" || u.Fragment != "" {
		return ""
	}
	scheme := strings.ToLower(u.Scheme)
	host := strings.ToLower(strings.TrimSuffix(u.Hostname(), "."))
	port := u.Port()
	if port == "" || (scheme == "https" && port == "443") || (scheme == "http" && port == "80") {
		return scheme + "://" + host
	}
	return scheme + "://" + host + ":" + port
}

// OpenTrustedStream follows only validated signed transfer URLs. Redirects are
// disabled so a trusted endpoint cannot redirect a credential-bearing request.
func (c *BridgeClient) OpenTrustedStream(ctx context.Context, target BridgeURL, method, contentType string, body io.Reader, contentLength int64, backup, websocket bool) (*http.Response, error) {
	u, err := c.TrustedTarget(ctx, target.URL, target.Host, backup, websocket)
	if err != nil {
		return nil, err
	}
	req, err := http.NewRequestWithContext(ctx, method, u.String(), body)
	if err != nil {
		return nil, errors.New("cannot create Panel transfer request")
	}
	if contentType != "" {
		req.Header.Set("Content-Type", contentType)
	}
	if contentLength >= 0 {
		req.ContentLength = contentLength
	}
	client := &http.Client{Timeout: 0, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}
	resp, err := client.Do(req)
	if err != nil {
		return nil, errors.New("Panel transfer failed")
	}
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		resp.Body.Close()
		return nil, fmt.Errorf("Panel transfer failed with status %d", resp.StatusCode)
	}
	return resp, nil
}
func (c *BridgeClient) UpdateVariable(ctx context.Context, uuid, key, value string) error {
	return c.put(ctx, "servers/"+url.PathEscape(uuid)+"/startup/variable", map[string]string{"key": key, "value": value}, nil)
}
func (c *BridgeClient) UpdateImage(ctx context.Context, uuid, image string) error {
	return c.put(ctx, "servers/"+url.PathEscape(uuid)+"/startup/image", map[string]string{"image": image}, nil)
}
