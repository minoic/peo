package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/config"
)

// buildEngine initialises the configuration inside a throwaway directory and
// builds the real router. Gin panics at registration time when two routes
// conflict, so simply constructing the engine is the assertion that the whole
// route table is expressible as one radix tree.
func buildEngine(t *testing.T) *gin.Engine {
	t.Helper()

	dir := t.TempDir()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	if err := os.Chdir(dir); err != nil {
		t.Fatalf("chdir: %v", err)
	}
	t.Cleanup(func() { _ = os.Chdir(wd) })

	gin.SetMode(gin.TestMode)
	if err := config.Init(); err != nil {
		t.Fatalf("config init: %v", err)
	}
	return Router()
}

// routeSet collects "METHOD path" for every registered handler.
func routeSet(t *testing.T, r *gin.Engine) map[string]bool {
	t.Helper()
	set := map[string]bool{}
	for _, route := range r.Routes() {
		set[route.Method+" "+route.Path] = true
	}
	return set
}

func assertRoutes(t *testing.T, set map[string]bool, want []string) {
	t.Helper()
	var missing []string
	for _, w := range want {
		if !set[w] {
			missing = append(missing, w)
		}
	}
	if len(missing) > 0 {
		sort.Strings(missing)
		t.Errorf("routes missing from the table:\n\t%s", strings.Join(missing, "\n\t"))
	}

	// The reverse direction matters as much: an accidentally registered route is
	// reachable by a client, so it is part of the contract whether or not anyone
	// wrote it down.
	known := make(map[string]bool, len(want))
	for _, w := range want {
		known[w] = true
	}
	var extra []string
	for got := range set {
		if !known[got] {
			extra = append(extra, got)
		}
	}
	if len(extra) > 0 {
		sort.Strings(extra)
		t.Errorf("routes registered but absent from the table:\n\t%s", strings.Join(extra, "\n\t"))
	}
}

// routeTable is the frozen contract between the server and the Flutter client.
// Every handler doc-comment appears here exactly once.
var routeTable = []string{
	// public / optional auth
	"GET /api/v1/site/config",
	"GET /api/v1/site/storefront",
	"GET /api/v1/products/:specId",
	"GET /api/v1/nests/:nestId/eggs",
	"GET /api/v1/tags/:tagSlug/eggs",
	"POST /api/v1/auth/login",
	"POST /api/v1/auth/register",
	"GET /api/v1/auth/confirm-email/:key",
	"POST /api/v1/auth/forget-password",
	"POST /api/v1/auth/reset-password",
	"POST /api/v1/alipay/notify",
	"GET /api/v1/gallery",

	// authenticated
	"POST /api/v1/auth/logout",
	"GET /api/v1/auth/me",
	"PUT /api/v1/user/password",
	"PUT /api/v1/user/email",
	"POST /api/v1/user/email/confirm",
	"POST /api/v1/user/pterodactyl-user",
	"POST /api/v1/orders",
	"GET /api/v1/orders",
	"GET /api/v1/orders/:id",
	"GET /api/v1/orders/:id/allocations",
	"POST /api/v1/orders/:id/pay",
	"POST /api/v1/orders/:id/pay-by-balance",
	"GET /api/v1/servers",
	"GET /api/v1/servers/status",
	"GET /api/v1/servers/:id",
	"POST /api/v1/servers/:id/renew",
	"POST /api/v1/servers/:id/renew-by-balance",
	"POST /api/v1/servers/:id/reinstall",
	"POST /api/v1/servers/:id/delete",
	"GET /api/v1/servers/:id/console",
	"GET /api/v1/servers/:id/resources",
	"POST /api/v1/servers/:id/power",
	"POST /api/v1/servers/:id/command",
	"POST /api/v1/servers/:id/terminal-ticket",
	"GET /api/v1/servers/:id/files",
	"POST /api/v1/servers/:id/files/read",
	"PUT /api/v1/servers/:id/files/write",
	"POST /api/v1/servers/:id/files/:action",
	"GET /api/v1/servers/:id/files/download",
	"PUT /api/v1/servers/:id/files/upload",
	"GET /api/v1/servers/:id/backups",
	"POST /api/v1/servers/:id/backups",
	"GET /api/v1/servers/:id/backups/:backupId/download",
	"POST /api/v1/servers/:id/backups/:backupId/:action",
	"DELETE /api/v1/servers/:id/backups/:backupId",
	"GET /api/v1/servers/:id/startup",
	"PUT /api/v1/servers/:id/startup/variable",
	"PUT /api/v1/servers/:id/startup/image",
	"GET /api/v1/gallery/mine",
	"POST /api/v1/gallery",
	"POST /api/v1/gallery/:id/like",
	"DELETE /api/v1/gallery/:id",
	"GET /api/v1/messages",
	"GET /api/v1/messages/unread",
	"POST /api/v1/messages/:id/read",
	"POST /api/v1/messages/read-all",
	"DELETE /api/v1/messages/:id",
	"GET /api/v1/work-orders",
	"POST /api/v1/work-orders",
	"GET /api/v1/recharge/logs",
	"POST /api/v1/recharge/key",
	"POST /api/v1/recharge/alipay",
	"GET /api/v1/recharge/alipay/:outTradeNo",

	// admin
	"GET /api/v1/admin/dashboard",
	"GET /api/v1/admin/users",
	"GET /api/v1/admin/orders",
	"GET /api/v1/admin/products",
	"GET /api/v1/admin/products/raw",
	"GET /api/v1/admin/products/form",
	"GET /api/v1/admin/panel/tags",
	"GET /api/v1/admin/panel/tags/:tagSlug/eggs",
	"POST /api/v1/admin/products",
	"PUT /api/v1/admin/products/:specId",
	"DELETE /api/v1/admin/products/:specId",
	"GET /api/v1/admin/key-targets",
	"POST /api/v1/admin/keys",
	"GET /api/v1/admin/keys/export",
	"GET /api/v1/admin/delete-confirms",
	"POST /api/v1/admin/delete-confirms/:entityId",
	"GET /api/v1/admin/work-orders",
	"POST /api/v1/admin/work-orders/:id/close",
	"POST /api/v1/admin/gallery/:id/:action",
	"GET /api/v1/admin/settings",
	"PUT /api/v1/admin/settings",
	"GET /api/v1/admin/health",

	// liveness
	"GET /healthz",
	"GET /api/v1/servers/:id/terminal",
}

func TestConsoleRoutesRequireAuthenticationAndTerminalTicketOrigin(t *testing.T) {
	r := buildEngine(t)
	protected := []struct {
		method string
		path   string
	}{
		{http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/console"},
		{http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/resources"},
		{http.MethodPost, "/api/v1/servers/507f1f77bcf86cd799439011/power"},
		{http.MethodPost, "/api/v1/servers/507f1f77bcf86cd799439011/command"},
		{http.MethodPost, "/api/v1/servers/507f1f77bcf86cd799439011/terminal-ticket"},
		{http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/files"},
		{http.MethodPost, "/api/v1/servers/507f1f77bcf86cd799439011/files/read"},
		{http.MethodPut, "/api/v1/servers/507f1f77bcf86cd799439011/files/write"},
		{http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/backups"},
		{http.MethodPost, "/api/v1/servers/507f1f77bcf86cd799439011/backups"},
		{http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/startup"},
		{http.MethodPut, "/api/v1/servers/507f1f77bcf86cd799439011/startup/image"},
	}
	for _, tc := range protected {
		rec := httptest.NewRecorder()
		r.ServeHTTP(rec, httptest.NewRequest(tc.method, tc.path, strings.NewReader(`{}`)))
		if rec.Code != http.StatusUnauthorized {
			t.Errorf("%s %s returned %d without a bearer token, want 401", tc.method, tc.path, rec.Code)
		}
	}

	if err := config.LoadSettings(map[string]any{"ConsoleOrigins": "https://peo.example"}); err != nil {
		t.Fatal(err)
	}
	terminalPath := "/api/v1/servers/507f1f77bcf86cd799439011/terminal?ticket=invalid"
	badOrigin := httptest.NewRecorder()
	badReq := httptest.NewRequest(http.MethodGet, terminalPath, nil)
	badReq.Header.Set("Origin", "https://evil.example")
	r.ServeHTTP(badOrigin, badReq)
	if badOrigin.Code != http.StatusForbidden {
		t.Errorf("terminal with an untrusted Origin returned %d, want 403", badOrigin.Code)
	}
	noTicket := httptest.NewRecorder()
	noTicketReq := httptest.NewRequest(http.MethodGet, "/api/v1/servers/507f1f77bcf86cd799439011/terminal", nil)
	noTicketReq.Header.Set("Origin", "https://peo.example")
	r.ServeHTTP(noTicket, noTicketReq)
	if noTicket.Code != http.StatusUnauthorized {
		t.Errorf("terminal without a ticket returned %d, want 401", noTicket.Code)
	}
}

func TestRouterRouteTable(t *testing.T) {
	set := routeSet(t, buildEngine(t))
	assertRoutes(t, set, routeTable)

	// Captcha is gone from the target architecture: the Redis rate limiters
	// replaced it, so these two legacy routes must not reappear.
	for _, gone := range []string{
		"GET /api/v1/auth/captcha",
		"POST /api/v1/auth/captcha",
		"GET /api/v1/user/email/captcha",
		"POST /api/v1/user/email/captcha",
	} {
		if set[gone] {
			t.Errorf("captcha route %q must not be registered", gone)
		}
	}
}

// TestGalleryRouteAuthenticationBindings pins the public feed and protected gallery actions.
func TestGalleryRouteAuthenticationBindings(t *testing.T) {
	r := buildEngine(t)

	// The public listing must reach its handler rather than be rejected by Auth.
	// No MongoDB is configured in this router test, so its handler-level failure
	// is expected; the 401 distinction pins the middleware binding.
	publicRec := httptest.NewRecorder()
	publicReq := httptest.NewRequest(http.MethodGet, "/api/v1/gallery", nil)
	r.ServeHTTP(publicRec, publicReq)
	if publicRec.Code == http.StatusUnauthorized {
		t.Fatalf("GET /api/v1/gallery was rejected as unauthenticated: %s", publicRec.Body.String())
	}

	for _, tc := range []struct {
		method string
		path   string
	}{
		{http.MethodGet, "/api/v1/gallery/mine"},
		{http.MethodPost, "/api/v1/gallery"},
		{http.MethodPost, "/api/v1/gallery/507f1f77bcf86cd799439011/like"},
		{http.MethodDelete, "/api/v1/gallery/507f1f77bcf86cd799439011"},
	} {
		rec := httptest.NewRecorder()
		req := httptest.NewRequest(tc.method, tc.path, strings.NewReader(`{"itemName":"test","imgSource":"https://example.test/image.png"}`))
		r.ServeHTTP(rec, req)
		if rec.Code != http.StatusUnauthorized {
			t.Errorf("%s %s status = %d, want %d", tc.method, tc.path, rec.Code, http.StatusUnauthorized)
		}
	}
}

// TestRouterStaticAndWildcardSiblings pins the precedence the client depends on:
// a literal segment next to a wildcard of the same depth must keep resolving to
// the literal handler.
func TestRouterStaticAndWildcardSiblings(t *testing.T) {
	r := buildEngine(t)

	// The SPA fallback answers with the envelope error when WebRoot holds no
	// index.html, so "not the fallback" is observable through the status code:
	// NoRoute writes 404 for an unmatched /api path.
	cases := []struct {
		method string
		path   string
		want   int
	}{
		// unmatched api paths fall through to the SPA handler, which refuses
		// to serve html for /api/*
		{http.MethodGet, "/api/v1/definitely-not-a-route", http.StatusNotFound},
	}

	for _, tc := range cases {
		rec := httptest.NewRecorder()
		req := httptest.NewRequest(tc.method, tc.path, nil)
		r.ServeHTTP(rec, req)
		if rec.Code != tc.want {
			t.Errorf("%s %s: status = %d, want %d", tc.method, tc.path, rec.Code, tc.want)
		}
	}
}

// TestHealthzShape pins the one response body that is not wrapped in the
// envelope. The container HEALTHCHECK reads the status code, but an operator
// reads the body, so both are asserted. Mongo' and Redis' addresses point at a
// port nothing is listening on, so all three components report down and the
// route must answer 503 -- which is exactly the interesting branch.
func TestHealthzShape(t *testing.T) {
	r := buildEngine(t)

	rec := httptest.NewRecorder()
	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	r.ServeHTTP(rec, req)

	if rec.Code != http.StatusServiceUnavailable {
		t.Fatalf("status = %d, want %d (nothing is listening on mongo or redis)", rec.Code, http.StatusServiceUnavailable)
	}

	var body map[string]any
	if err := json.Unmarshal(rec.Body.Bytes(), &body); err != nil {
		t.Fatalf("decode body %q: %v", rec.Body.String(), err)
	}
	for _, key := range []string{"ok", "mongo", "redis", "pterodactyl"} {
		if _, present := body[key]; !present {
			t.Errorf("body %v is missing required key %q", body, key)
		}
	}
	if body["ok"] != false {
		t.Errorf(`body["ok"] = %v, want false so an orchestrator can read either the code or the body`, body["ok"])
	}
	// A failed component must explain itself under "<name>_error".
	if _, present := body["mongo_error"]; !present {
		t.Errorf("body %v is missing the mongo_error message", body)
	}
	// The envelope must not leak into this route: it is consumed by curl in a
	// HEALTHCHECK, not by the SPA.
	if _, present := body["data"]; present {
		t.Errorf("body %v must be a bare object, not the {ok,data,error} envelope", body)
	}
}
