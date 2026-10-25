package pterodactyl

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/minoic/peo/server/internal/config"
)

func newPanel2TestClient(t *testing.T, handler http.Handler) *Client {
	t.Helper()
	server := httptest.NewServer(handler)
	t.Cleanup(server.Close)
	previous := config.Settings()
	if err := config.LoadSettings(map[string]any{
		"PterodactylHostname": server.URL,
		"PterodactylToken":    "panel2-test-token",
	}); err != nil {
		t.Fatalf("configure Panel 2 test client: %v", err)
	}
	t.Cleanup(func() {
		if err := config.LoadSettings(previous); err != nil {
			t.Errorf("restore Panel configuration: %v", err)
		}
	})

	return NewClient(server.URL, "panel2-test-token")
}

func TestTagForLegacyNestRequiresOneMapping(t *testing.T) {
	tests := []struct {
		name string
		data string
		want bool
	}{
		{
			name: "unique mapping",
			data: `{"data":[{"attributes":{"id":11,"name":"Minecraft","slug":"minecraft","legacy_nest_id":7}},{"attributes":{"id":12,"name":"Other","slug":"other","legacy_nest_id":8}}],"meta":{"pagination":{"total_pages":1}}}`,
			want: true,
		},
		{
			name: "no mapping",
			data: `{"data":[{"attributes":{"id":11,"name":"Minecraft","slug":"minecraft","legacy_nest_id":null}}],"meta":{"pagination":{"total_pages":1}}}`,
		},
		{
			name: "ambiguous mapping",
			data: `{"data":[{"attributes":{"id":11,"name":"Minecraft","slug":"minecraft","legacy_nest_id":7}},{"attributes":{"id":13,"name":"Minecraft duplicate","slug":"minecraft-copy","legacy_nest_id":7}}],"meta":{"pagination":{"total_pages":1}}}`,
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodGet || r.URL.Path != "/api/application/tags" || r.URL.Query().Get("page") != "1" {
					http.Error(w, "unexpected Panel request", http.StatusNotFound)
					return
				}
				w.Header().Set("Content-Type", "application/json")
				_, _ = io.WriteString(w, test.data)
			}))
			tag, err := client.TagForLegacyNest(context.Background(), 7)
			if test.want {
				if err != nil || tag == nil || tag.ID != 11 || tag.Slug != "minecraft" || tag.LegacyNestID == nil || *tag.LegacyNestID != 7 {
					t.Fatalf("TagForLegacyNest() = %#v, %v", tag, err)
				}
				return
			}
			if err == nil || tag != nil {
				t.Fatalf("TagForLegacyNest() = %#v, %v, want mapping error", tag, err)
			}
		})
	}
}

func TestEggHasTagReadsPanel2EggRelationships(t *testing.T) {
	const eggID = 992731
	client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet || r.URL.Path != "/api/application/eggs/"+strconv.Itoa(eggID) || r.URL.Query().Get("include") != "tags" {
			http.Error(w, "unexpected Panel request", http.StatusNotFound)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, `{"attributes":{"id":992731,"name":"Paper","relationships":{"tags":{"data":[{"attributes":{"id":21,"name":"Minecraft","slug":"minecraft","legacy_nest_id":7}}]}}}}`)
	}))

	hasTag, err := client.EggHasTag(context.Background(), eggID, "minecraft")
	if err != nil || !hasTag {
		t.Fatalf("EggHasTag() = %v, %v", hasTag, err)
	}
}

func TestCreateServerSendsPanel2EggAndResolvedStartupFields(t *testing.T) {
	const eggID = 993741
	var requestBody map[string]any
	client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		switch {
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/tags":
			_, _ = io.WriteString(w, `{"data":[{"attributes":{"id":21,"name":"Minecraft","slug":"minecraft","legacy_nest_id":7}}],"meta":{"pagination":{"total_pages":1}}}`)
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/eggs/"+strconv.Itoa(eggID) && r.URL.Query().Get("include") == "tags":
			_, _ = io.WriteString(w, `{"attributes":{"id":993741,"name":"Paper","docker_image":"ghcr.io/example/java:21","docker_images":{"Java 21":"ghcr.io/example/java:21"},"startup":"java -jar server.jar","relationships":{"tags":{"data":[{"attributes":{"slug":"minecraft","legacy_nest_id":7}}]}}}}`)
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/eggs/"+strconv.Itoa(eggID) && r.URL.Query().Get("include") == "variables":
			_, _ = io.WriteString(w, `{"attributes":{"relationships":{"variables":{"data":[{"attributes":{"env_variable":"SERVER_JARFILE","default_value":"server.jar"}}]}}}}`)
		case r.Method == http.MethodPost && r.URL.Path == "/api/application/servers":
			if err := json.NewDecoder(r.Body).Decode(&requestBody); err != nil {
				t.Errorf("decode server creation request: %v", err)
			}
			w.WriteHeader(http.StatusCreated)
			_, _ = io.WriteString(w, `{"attributes":{"id":991,"identifier":"server123"}}`)
		default:
			http.Error(w, "unexpected Panel request", http.StatusNotFound)
		}
	}))

	err := client.CreateServer(context.Background(), Server{
		ExternalId:    "peo-order-1",
		Name:          "peo-order-1",
		NestId:        7,
		EggId:         eggID,
		TagSlug:       "minecraft",
		AllowedEggIDs: []int{eggID},
		DockerImage:   "ghcr.io/example/java:21",
		UserId:        99,
		NodeId:        12,
		Allocation:    65000,
	})
	if err != nil {
		t.Fatalf("CreateServer() error = %v", err)
	}
	if requestBody["egg"] != float64(eggID) || requestBody["docker_image"] != "ghcr.io/example/java:21" || requestBody["startup"] != "java -jar server.jar" {
		t.Fatalf("Panel 2 server creation fields = %#v", requestBody)
	}
	if requestBody["nest"] != nil {
		t.Fatalf("Panel 2 server creation unexpectedly sent legacy nest: %#v", requestBody)
	}
	environment, ok := requestBody["environment"].(map[string]any)
	if !ok || environment["SERVER_JARFILE"] != "server.jar" {
		t.Fatalf("Panel 2 server creation environment = %#v", requestBody["environment"])
	}
}

func TestUpdateServerStartupPatchesRequestedEggNotCurrentEggOrPack(t *testing.T) {
	const (
		externalID  = "peo-reinstall-993751"
		serverID    = 88751
		oldEggID    = 41
		targetEggID = 42
	)
	var patchBody map[string]any
	client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		switch {
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/servers/external/"+externalID:
			_, _ = io.WriteString(w, `{"attributes":{"id":88751,"external_id":"peo-reinstall-993751","nest":7,"egg":41}}`)
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/eggs/"+strconv.Itoa(targetEggID) && r.URL.Query().Get("include") == "tags":
			_, _ = io.WriteString(w, `{"attributes":{"id":42,"name":"Fabric","docker_image":"ghcr.io/example/java:21","startup":"java -jar fabric.jar","relationships":{"tags":{"data":[{"attributes":{"slug":"minecraft","legacy_nest_id":7}}]}}}}`)
		case r.Method == http.MethodGet && r.URL.Path == "/api/application/eggs/"+strconv.Itoa(targetEggID) && r.URL.Query().Get("include") == "variables":
			_, _ = io.WriteString(w, `{"attributes":{"relationships":{"variables":{"data":[{"attributes":{"env_variable":"SERVER_JARFILE","default_value":"fabric.jar"}}]}}}}`)
		case r.Method == http.MethodPatch && r.URL.Path == "/api/application/servers/"+strconv.Itoa(serverID)+"/startup":
			if err := json.NewDecoder(r.Body).Decode(&patchBody); err != nil {
				t.Errorf("decode startup update request: %v", err)
			}
		default:
			http.Error(w, "unexpected Panel request", http.StatusNotFound)
		}
	}))

	err := client.UpdateServerStartup(context.Background(), externalID, targetEggID)
	if err != nil {
		t.Fatalf("UpdateServerStartup() error = %v", err)
	}
	if patchBody["egg"] != float64(targetEggID) || patchBody["startup"] != "java -jar fabric.jar" || patchBody["image"] != "ghcr.io/example/java:21" {
		t.Fatalf("Panel 2 startup patch did not use target egg: %#v", patchBody)
	}
	if patchBody["egg"] == float64(oldEggID) || patchBody["pack"] != nil {
		t.Fatalf("Panel 2 startup patch used legacy egg/pack fields: %#v", patchBody)
	}
	environment, ok := patchBody["environment"].(map[string]any)
	if !ok || environment["SERVER_JARFILE"] != "fabric.jar" {
		t.Fatalf("Panel 2 startup patch environment = %#v", patchBody["environment"])
	}
}
