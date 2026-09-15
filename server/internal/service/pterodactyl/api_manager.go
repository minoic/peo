package pterodactyl

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/http/cookiejar"
	"strconv"
	"strings"
	"time"

	"github.com/bluele/gcache"
	"github.com/minoic/glgf"
)

// Cache lifetimes. The panel rarely changes a nest or an egg, but a server's
// state (suspended or not) is exactly what the expiry sweep inspects, so it gets
// the shortest window.
const (
	nestCacheTTL   = 3 * time.Minute
	eggCacheTTL    = time.Minute
	serverCacheTTL = time.Minute

	// maxConcurrentRequests bounds how many calls are in flight at once. The
	// legacy client used a buffered channel as a semaphore; a weighted
	// semaphore would work too, but the channel keeps the ordering guarantee
	// that the cache check happens before the slot is taken.
	maxConcurrentRequests = 4

	// requestTimeout bounds a single panel call. Without it a hung panel would
	// pin one of the four slots forever.
	requestTimeout = 30 * time.Second
)

var (
	// cache holds parsed panel responses keyed by resource, so a burst of
	// requests for the same nest does not fan out into a burst of API calls.
	cache = gcache.New(128).ARC().Build()

	// pool is the concurrency limiter shared by every client instance.
	pool = make(chan struct{}, maxConcurrentRequests)
)

// Client is a Pterodactyl Application API client.
//
// It is cheap to construct, so callers build one per request through
// ClientFromConf rather than holding a package level instance. That way a
// settings change is picked up immediately.
type Client struct {
	url   string
	token string
	http  *http.Client
}

// NewClient builds a client for a panel.
//
// The legacy implementation called strings.TrimRight without assigning the
// result, so a trailing slash in PterodactylHostname produced URLs with a double
// slash that the panel's router rejected. The trim is applied here, and
// config.Reload trims the setting as well.
func NewClient(url string, token string) *Client {
	return &Client{
		url:   strings.TrimRight(strings.TrimSpace(url), "/"),
		token: token,
		http:  &http.Client{Timeout: requestTimeout},
	}
}

// HostName returns the configured panel address.
func (c *Client) HostName() string { return c.url }

// Invalidate drops the cached entry for a resource. Mutating calls use it so the
// next read observes the change instead of a stale cache hit.
func Invalidate(keys ...string) {
	for _, key := range keys {
		cache.Remove(key)
	}
}

// InvalidateServer forgets a cached server document.
func InvalidateServer(externalID string) { cache.Remove(serverKey(externalID)) }

// InvalidateEggs forgets every cached egg list for a nest.
func InvalidateEggs(nestID int) {
	cache.Remove(nestKey(nestID))
	cache.Remove(eggsKey(nestID))
}

func nestKey(nestID int) string { return "NEST" + strconv.Itoa(nestID) }

func eggKey(nestID, eggID int) string {
	return nestKey(nestID) + "EGG" + strconv.Itoa(eggID)
}

func eggsKey(nestID int) string { return "ALLEGGS" + strconv.Itoa(nestID) }

func serverKey(externalID string) string { return "SERVER" + externalID }

// api performs one Application API call and returns the raw body.
//
// The panel rejects a request that is missing the bearer token or presents the
// wrong Accept header, so both are always set; nothing here depends on cookies.
func (c *Client) api(ctx context.Context, data interface{}, endPoint, method string) ([]byte, error) {
	if c.url == "" {
		return nil, errors.New("pterodactyl: hostname is not configured")
	}
	url := c.url + "/api/application/" + endPoint

	var body io.Reader
	if method == http.MethodPost || method == http.MethodPatch {
		buf := &bytes.Buffer{}
		if err := json.NewEncoder(buf).Encode(data); err != nil {
			return nil, fmt.Errorf("pterodactyl: cannot encode request body: %w", err)
		}
		body = buf
	}

	ctx, cancel := context.WithTimeout(ctx, requestTimeout)
	defer cancel()
	req, err := http.NewRequestWithContext(ctx, method, url, body)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Authorization", "Bearer "+c.token)
	req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}

	resp, err := c.http.Do(req)
	if err != nil {
		return nil, err
	}
	defer func() { _ = resp.Body.Close() }()
	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode >= http.StatusBadRequest {
		return nil, fmt.Errorf("pterodactyl: %s %s returned %d: %s",
			method, endPoint, resp.StatusCode, strings.TrimSpace(string(raw)))
	}
	return raw, nil
}

// cachedGet wraps a read in the concurrency limiter and the gcache layer. The
// cache is consulted before a slot is taken, so a warm cache never waits.
func cachedGet[T any](key string, ttl time.Duration, fetch func() (*T, error)) (*T, error) {
	if v, err := cache.Get(key); err == nil {
		return v.(*T), nil
	}
	pool <- struct{}{}
	defer func() { <-pool }()

	v, err := fetch()
	if err != nil {
		return nil, err
	}
	if err := cache.SetWithExpire(key, v, ttl); err != nil {
		glgf.Error("pterodactyl: cannot cache " + key + ": " + err.Error())
	}
	return v, nil
}

// TestConnection verifies the hostname and token by listing nodes.
func (c *Client) TestConnection(ctx context.Context) error {
	raw, err := c.api(ctx, nil, "nodes", http.MethodGet)
	glgf.Debug("pterodactyl api probe: ", string(raw))
	return err
}

// ---------------------------------------------------------------------------
// Users
// ---------------------------------------------------------------------------

// GetUser looks a panel account up by its external id. Every account this
// application creates uses the site user's ObjectID hex as its external id, so
// the lookup keeps working after a rename.
func (c *Client) GetUser(ctx context.Context, externalID string) (*User, error) {
	raw, err := c.api(ctx, nil, "users/external/"+externalID, http.MethodGet)
	if err != nil {
		return nil, err
	}
	var dec struct {
		Attributes User `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return nil, err
	}
	return &dec.Attributes, nil
}

// GetUserByID looks a panel account up by its numeric panel id.
func (c *Client) GetUserByID(ctx context.Context, id int) (*User, error) {
	raw, err := c.api(ctx, nil, "users/"+strconv.Itoa(id), http.MethodGet)
	if err != nil {
		return nil, err
	}
	var dec struct {
		Attributes User `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return nil, err
	}
	return &dec.Attributes, nil
}

// GetAllUsers returns every panel account, following pagination.
func (c *Client) GetAllUsers(ctx context.Context) ([]User, error) {
	return paged[User](ctx, c, "users")
}

// CreateUser provisions a panel account.
func (c *Client) CreateUser(ctx context.Context, info PostPteUser) error {
	_, err := c.api(ctx, info, "users", http.MethodPost)
	return err
}

// UpdateUser patches the mutable fields of a panel account.
func (c *Client) UpdateUser(ctx context.Context, panelID int, body map[string]interface{}) error {
	_, err := c.api(ctx, body, "users/"+strconv.Itoa(panelID), http.MethodPatch)
	return err
}

// ChangePassword sets a new panel password, preserving the other fields because
// the panel's PATCH replaces everything it is given.
func (c *Client) ChangePassword(ctx context.Context, externalID, password string) error {
	u, err := c.GetUser(ctx, externalID)
	if err != nil {
		return err
	}
	return c.UpdateUser(ctx, u.Uid, map[string]interface{}{
		"email":      u.Email,
		"username":   u.UserName,
		"first_name": u.FirstName,
		"last_name":  u.LastName,
		"password":   password,
	})
}

// ---------------------------------------------------------------------------
// Nests, eggs and nodes
// ---------------------------------------------------------------------------

// GetNest returns a nest, cached for three minutes.
func (c *Client) GetNest(ctx context.Context, nestID int) (*Nest, error) {
	return cachedGet(nestKey(nestID), nestCacheTTL, func() (*Nest, error) {
		raw, err := c.api(ctx, nil, "nests/"+strconv.Itoa(nestID), http.MethodGet)
		if err != nil {
			return nil, err
		}
		var dec struct {
			Attributes Nest `json:"attributes"`
		}
		if err := json.Unmarshal(raw, &dec); err != nil {
			return nil, err
		}
		return &dec.Attributes, nil
	})
}

// GetAllNests returns every nest.
func (c *Client) GetAllNests(ctx context.Context) ([]Nest, error) {
	return paged[Nest](ctx, c, "nests")
}

// GetEgg returns one egg of a nest, cached for a minute.
func (c *Client) GetEgg(ctx context.Context, nestID, eggID int) (*Egg, error) {
	return cachedGet(eggKey(nestID, eggID), eggCacheTTL, func() (*Egg, error) {
		raw, err := c.api(ctx, nil,
			"nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID), http.MethodGet)
		if err != nil {
			return nil, err
		}
		var dec struct {
			Attributes Egg `json:"attributes"`
		}
		if err := json.Unmarshal(raw, &dec); err != nil {
			return nil, err
		}
		return &dec.Attributes, nil
	})
}

// GetAllEggs returns every egg of a nest, cached for three minutes.
func (c *Client) GetAllEggs(ctx context.Context, nestID int) ([]Egg, error) {
	key := eggsKey(nestID)
	if v, err := cache.Get(key); err == nil {
		return v.([]Egg), nil
	}
	pool <- struct{}{}
	defer func() { <-pool }()

	eggs, err := paged[Egg](ctx, c, "nests/"+strconv.Itoa(nestID)+"/eggs")
	if err != nil {
		return nil, err
	}
	if err := cache.SetWithExpire(key, eggs, nestCacheTTL); err != nil {
		glgf.Error("pterodactyl: cannot cache " + key + ": " + err.Error())
	}
	return eggs, nil
}

// GetAllNodes returns every node.
func (c *Client) GetAllNodes(ctx context.Context) ([]Node, error) {
	return paged[Node](ctx, c, "nodes")
}

// GetNode returns one node.
func (c *Client) GetNode(ctx context.Context, nodeID int) (*Node, error) {
	raw, err := c.api(ctx, nil, "nodes/"+strconv.Itoa(nodeID), http.MethodGet)
	if err != nil {
		return nil, err
	}
	var dec struct {
		Attributes Node `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return nil, err
	}
	return &dec.Attributes, nil
}

// GetAllocations returns the free allocations of a node. Pages beyond the first
// are followed, otherwise a node with more than one page of allocations would
// appear full and no server could be provisioned on it.
func (c *Client) GetAllocations(ctx context.Context, nodeID int) ([]Allocation, error) {
	all, err := paged[Allocation](ctx, c, "nodes/"+strconv.Itoa(nodeID)+"/allocations")
	if err != nil {
		return nil, err
	}
	free := make([]Allocation, 0, len(all))
	for _, a := range all {
		if !a.Assigned {
			free = append(free, a)
		}
	}
	return free, nil
}

// GetEnv returns an egg's default environment variables, which the panel
// requires when a server is created.
func (c *Client) GetEnv(ctx context.Context, nestID, eggID int) (map[string]string, error) {
	raw, err := c.api(ctx, nil,
		"nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID)+"?include=variables", http.MethodGet)
	if err != nil {
		return nil, err
	}
	var dec struct {
		Attributes struct {
			Relationships struct {
				Variables struct {
					Data []struct {
						Attributes struct {
							EnvVariable  string `json:"env_variable"`
							DefaultValue string `json:"default_value"`
						} `json:"attributes"`
					} `json:"data"`
				} `json:"variables"`
			} `json:"relationships"`
		} `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return nil, err
	}
	// The legacy code type-asserted each value out of a map[string]interface{}
	// and panicked on a null default_value; decoding into a struct tolerates it.
	out := make(map[string]string)
	for _, v := range dec.Attributes.Relationships.Variables.Data {
		if v.Attributes.EnvVariable != "" {
			out[v.Attributes.EnvVariable] = v.Attributes.DefaultValue
		}
	}
	return out, nil
}

// ---------------------------------------------------------------------------
// Servers
// ---------------------------------------------------------------------------

// GetServer looks a server up by external id, cached for a minute.
func (c *Client) GetServer(ctx context.Context, externalID string) (*Server, error) {
	return cachedGet(serverKey(externalID), serverCacheTTL, func() (*Server, error) {
		raw, err := c.api(ctx, nil, "servers/external/"+externalID, http.MethodGet)
		if err != nil {
			return nil, err
		}
		var dec struct {
			Attributes Server `json:"attributes"`
		}
		if err := json.Unmarshal(raw, &dec); err != nil {
			return nil, err
		}
		return &dec.Attributes, nil
	})
}

// GetServerByID looks a server up by its numeric panel id.
func (c *Client) GetServerByID(ctx context.Context, id int) (*Server, error) {
	raw, err := c.api(ctx, nil, "servers/"+strconv.Itoa(id), http.MethodGet)
	if err != nil {
		return nil, err
	}
	var dec struct {
		Attributes Server `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return nil, err
	}
	return &dec.Attributes, nil
}

// GetAllServers returns every server on the panel.
func (c *Client) GetAllServers(ctx context.Context) ([]Server, error) {
	return paged[Server](ctx, c, "servers")
}

// GetServerID resolves an external id to the numeric panel id, or 0 when the
// server does not exist.
func (c *Client) GetServerID(ctx context.Context, externalID string) int {
	s, err := c.GetServer(ctx, externalID)
	if err != nil {
		return 0
	}
	return s.Id
}

func (c *Client) serverAction(ctx context.Context, externalID, action string) error {
	id := c.GetServerID(ctx, externalID)
	if id == 0 {
		return errors.New("pterodactyl: server not found: " + externalID)
	}
	if _, err := c.api(ctx, nil, "servers/"+strconv.Itoa(id)+"/"+action, http.MethodPost); err != nil {
		return err
	}
	// The cached copy is now wrong: a suspend flips the suspended flag.
	InvalidateServer(externalID)
	return nil
}

// SuspendServer stops a server without deleting it.
func (c *Client) SuspendServer(ctx context.Context, externalID string) error {
	return c.serverAction(ctx, externalID, "suspend")
}

// UnsuspendServer lets a suspended server start again.
func (c *Client) UnsuspendServer(ctx context.Context, externalID string) error {
	return c.serverAction(ctx, externalID, "unsuspend")
}

// ReinstallServer re-runs the egg install script.
func (c *Client) ReinstallServer(ctx context.Context, externalID string) error {
	return c.serverAction(ctx, externalID, "reinstall")
}

// DeleteServer removes a server and everything attached to it.
func (c *Client) DeleteServer(ctx context.Context, externalID string) error {
	id := c.GetServerID(ctx, externalID)
	if id == 0 {
		return errors.New("pterodactyl: server not found: " + externalID)
	}
	if _, err := c.api(ctx, nil, "servers/"+strconv.Itoa(id), http.MethodDelete); err != nil {
		return err
	}
	InvalidateServer(externalID)
	return nil
}

// CreateServer provisions a server from a product definition. The egg supplies
// the docker image, the startup command and the default environment, so they are
// resolved here rather than being stored on the product.
func (c *Client) CreateServer(ctx context.Context, s Server) error {
	egg, err := c.GetEgg(ctx, s.NestId, s.EggId)
	if err != nil {
		return err
	}
	env, err := c.GetEnv(ctx, s.NestId, s.EggId)
	if err != nil {
		return err
	}
	body := map[string]interface{}{
		"name":         s.Name,
		"user":         s.UserId,
		"nest":         s.NestId,
		"egg":          s.EggId,
		"docker_image": egg.DockerImage,
		"startup":      egg.StartUp,
		"description":  s.Description,
		"oom_disabled": s.Limits.OOMDisabled,
		"limits": map[string]interface{}{
			"memory":       s.Limits.Memory,
			"swap":         s.Limits.Swap,
			"io":           s.Limits.IO,
			"cpu":          s.Limits.CPU,
			"disk":         s.Limits.Disk,
			"oom_disabled": s.Limits.OOMDisabled,
		},
		"feature_limits": map[string]interface{}{
			"databases":   s.FeatureLimits.Databases,
			"allocations": s.FeatureLimits.Allocations,
			"backups":     s.FeatureLimits.Backups,
		},
		"environment": env,
		// The server is left stopped so the customer can review it before the
		// install script runs and consumes resources.
		"start_on_completion": false,
		"external_id":         s.ExternalId,
		"allocation": map[string]interface{}{
			"default": s.Allocation,
		},
	}
	raw, err := c.api(ctx, body, "servers", http.MethodPost)
	if err != nil {
		return err
	}
	var dec struct {
		Attributes Server `json:"attributes"`
	}
	if err := json.Unmarshal(raw, &dec); err != nil {
		return err
	}
	// The panel answers 201 with an empty attributes object when it accepts the
	// request but fails to queue the creation; treating that as success would
	// leave a paid order without a server, so it is an error.
	if dec.Attributes == (Server{}) {
		return errors.New("pterodactyl: create server returned an empty object: " + string(raw))
	}
	glgf.Info("pterodactyl: created server ", dec.Attributes.Identifier, " for external id ", s.ExternalId)
	return nil
}

// UpdateServerDetail changes the name, owner and description of a server.
func (c *Client) UpdateServerDetail(ctx context.Context, externalID string, d PostUpdateDetails) error {
	id := c.GetServerID(ctx, externalID)
	if id == 0 {
		return errors.New("pterodactyl: server not found: " + externalID)
	}
	body := map[string]interface{}{
		"user":        d.UserID,
		"description": d.Description,
		"name":        d.ServerName,
		"external_id": d.ExternalID,
	}
	if _, err := c.api(ctx, body, "servers/"+strconv.Itoa(id)+"/details", http.MethodPatch); err != nil {
		return err
	}
	InvalidateServer(externalID)
	return nil
}

// UpdateServerBuild changes the resource limits and the primary allocation.
func (c *Client) UpdateServerBuild(ctx context.Context, externalID string, b PostUpdateBuild) error {
	id := c.GetServerID(ctx, externalID)
	if id == 0 {
		return errors.New("pterodactyl: server not found: " + externalID)
	}
	body := map[string]interface{}{
		"allocation":   b.Allocation,
		"memory":       b.Memory,
		"io":           b.IO,
		"swap":         b.Swap,
		"cpu":          b.CPU,
		"disk":         b.Disk,
		"oom_disabled": b.OomDisabled,
		"feature_limits": map[string]interface{}{
			"databases":   b.Database,
			"allocations": b.Allocations,
		},
	}
	if _, err := c.api(ctx, body, "servers/"+strconv.Itoa(id)+"/build", http.MethodPatch); err != nil {
		return err
	}
	InvalidateServer(externalID)
	return nil
}

// UpdateServerStartup re-points a server at another egg, which is how a
// reinstall with a different game type is expressed.
func (c *Client) UpdateServerStartup(ctx context.Context, externalID string, packID int) error {
	s, err := c.GetServer(ctx, externalID)
	if err != nil {
		return err
	}
	egg, err := c.GetEgg(ctx, s.NestId, s.EggId)
	if err != nil {
		return err
	}
	env, err := c.GetEnv(ctx, s.NestId, s.EggId)
	if err != nil {
		return err
	}
	body := map[string]interface{}{
		"environment":  env,
		"startup":      egg.StartUp,
		"egg":          s.EggId,
		"pack":         packID,
		"image":        egg.DockerImage,
		"skip_scripts": false,
	}
	if _, err := c.api(ctx, body, "servers/"+strconv.Itoa(s.Id)+"/startup", http.MethodPatch); err != nil {
		return err
	}
	InvalidateServer(externalID)
	return nil
}

// ---------------------------------------------------------------------------
// Authentication handover
// ---------------------------------------------------------------------------

// Login authenticates against the panel's own front end and returns the value of
// the pterodactyl_session cookie, which the caller plants on the shared parent
// domain so the customer does not have to sign in twice.
//
// The panel protects /auth/login with Laravel's CSRF token, so the cookie
// endpoint is called first and the XSRF-TOKEN value is replayed in the header.
func (c *Client) Login(ctx context.Context, email, password string) (string, error) {
	if c.url == "" {
		return "", errors.New("pterodactyl: hostname is not configured")
	}
	jar, err := cookiejar.New(nil)
	if err != nil {
		return "", err
	}
	client := &http.Client{Jar: jar, Timeout: requestTimeout}

	// Step one: obtain the XSRF-TOKEN cookie.
	csrfReq, err := http.NewRequestWithContext(ctx, http.MethodGet, c.url+"/sanctum/csrf-cookie", nil)
	if err != nil {
		return "", err
	}
	csrfResp, err := client.Do(csrfReq)
	if err != nil {
		return "", err
	}
	_ = csrfResp.Body.Close()

	var xsrf string
	for _, ck := range csrfResp.Cookies() {
		if ck.Name == "XSRF-TOKEN" {
			xsrf = ck.Value
		}
	}
	if xsrf == "" {
		// Laravel URL-encodes the cookie value; the header wants it decoded.
		// A missing cookie means the panel is not reachable or the endpoint
		// moved, and the login below would fail with an opaque 419.
		return "", errors.New("pterodactyl: no XSRF-TOKEN cookie, cannot sign in")
	}

	// Step two: post the credentials with the token replayed.
	buf := &bytes.Buffer{}
	if err := json.NewEncoder(buf).Encode(map[string]interface{}{
		"user":                 email,
		"password":             password,
		"g-recaptcha-response": "",
	}); err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.url+"/auth/login", buf)
	if err != nil {
		return "", err
	}
	req.Header.Set("x-xsrf-token", strings.ReplaceAll(xsrf, "%3D", "="))
	req.Header.Set("origin", c.url)
	req.Header.Set("referer", c.url+"/auth/login")
	req.Header.Set("accept", "application/json")
	req.Header.Set("content-type", "application/json")
	req.Header.Set("user-agent", "peo/1.0 (+"+c.url+")")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer func() { _ = resp.Body.Close() }()
	raw, _ := io.ReadAll(resp.Body)

	for _, ck := range resp.Cookies() {
		if ck.Name == "pterodactyl_session" {
			return ck.Value, nil
		}
	}
	if resp.StatusCode >= http.StatusBadRequest {
		return "", fmt.Errorf("pterodactyl: login returned %d: %s",
			resp.StatusCode, strings.TrimSpace(string(raw)))
	}
	return "", errors.New("pterodactyl: no pterodactyl_session cookie in login response")
}

// ---------------------------------------------------------------------------
// Pagination
// ---------------------------------------------------------------------------

// pageEnvelope is the paginated shape the Application API uses for list
// endpoints.
type pageEnvelope[T any] struct {
	Data []struct {
		Attributes T `json:"attributes"`
	} `json:"data"`
	Meta struct {
		Pagination struct {
			TotalPages  int `json:"total_pages"`
			CurrentPage int `json:"current_page"`
		} `json:"pagination"`
	} `json:"meta"`
}

// paged fetches every page of a list endpoint.
//
// The legacy client read only the first page, so a panel with more than fifty
// servers or users silently reported a partial inventory. The loop is bounded to
// avoid an unbounded walk if the panel keeps reporting another page.
func paged[T any](ctx context.Context, c *Client, endPoint string) ([]T, error) {
	const maxPages = 100
	sep := "?"
	if strings.Contains(endPoint, "?") {
		sep = "&"
	}

	out := make([]T, 0)
	for page := 1; page <= maxPages; page++ {
		raw, err := c.api(ctx, nil, endPoint+sep+"page="+strconv.Itoa(page), http.MethodGet)
		if err != nil {
			return nil, err
		}
		var dec pageEnvelope[T]
		if err := json.Unmarshal(raw, &dec); err != nil {
			return nil, err
		}
		for _, v := range dec.Data {
			out = append(out, v.Attributes)
		}
		if dec.Meta.Pagination.TotalPages <= page || len(dec.Data) == 0 {
			break
		}
	}
	return out, nil
}
