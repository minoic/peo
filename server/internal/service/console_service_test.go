package service

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestConsoleEntityAuthorizationUsesCurrentOwnerAndAdmin(t *testing.T) {
	owner := bson.NewObjectID()
	other := bson.NewObjectID()
	entity := &models.WareEntity{ID: bson.NewObjectID(), UserID: owner}
	service := ConsoleService{loadEntity: func(context.Context, bson.ObjectID) (*models.WareEntity, error) {
		return entity, nil
	}}

	if _, err := service.entity(context.Background(), entity.ID, other, false); err == nil {
		t.Fatal("non-owner was authorized")
	} else {
		var apiError *apierr.Error
		if !errors.As(err, &apiError) || apiError.Code != apierr.CodeForbidden {
			t.Fatalf("non-owner error = %v, want forbidden", err)
		}
	}
	got, err := service.entity(context.Background(), entity.ID, owner, false)
	if err != nil || got.ID != entity.ID {
		t.Fatalf("owner access = (%v, %v), want entity", got, err)
	}
	got, err = service.entity(context.Background(), entity.ID, other, true)
	if err != nil || got.ID != entity.ID {
		t.Fatalf("admin access = (%v, %v), want entity", got, err)
	}
}

func TestTerminalTicketOneShotExpiryRevocationAndOwnership(t *testing.T) {
	owner := bson.NewObjectID()
	entityID := bson.NewObjectID()
	entity := &models.WareEntity{ID: entityID, UserID: owner}
	user := &models.User{ID: owner}
	state := &terminalSessions{tickets: map[string]terminalTicket{}, active: map[[32]byte]map[string]context.CancelFunc{}}
	service := ConsoleService{
		terminalState: state,
		loadUser:      func(context.Context, bson.ObjectID) (*models.User, error) { return user, nil },
		loadEntity:    func(context.Context, bson.ObjectID) (*models.WareEntity, error) { return entity, nil },
		tokenRevoked:  func(context.Context, string) bool { return false },
	}
	token := "ticket-test-token"
	claims := &auth.Claims{ID: "jti-1", Expires: time.Now().Add(time.Hour)}
	ticket, err := createTerminalTicket(state, owner, entityID, false, token, claims, time.Now())
	if err != nil {
		t.Fatal(err)
	}
	consumed, ok := service.consumeTerminalTicket(context.Background(), ticket.Ticket)
	if !ok || consumed.Entity != entityID || consumed.User != owner {
		t.Fatalf("ticket consumption = (%+v, %v)", consumed, ok)
	}
	if _, ok := service.consumeTerminalTicket(context.Background(), ticket.Ticket); ok {
		t.Fatal("ticket was consumed more than once")
	}

	expired, err := createTerminalTicket(state, owner, entityID, false, token, claims, time.Now().Add(-time.Minute))
	if err != nil {
		t.Fatal(err)
	}
	if _, ok := service.consumeTerminalTicket(context.Background(), expired.Ticket); ok {
		t.Fatal("expired ticket was accepted")
	}

	revokedTicket, err := createTerminalTicket(state, owner, entityID, false, token, claims, time.Now())
	if err != nil {
		t.Fatal(err)
	}
	service.tokenRevoked = func(context.Context, string) bool { return true }
	if _, ok := service.consumeTerminalTicket(context.Background(), revokedTicket.Ticket); ok {
		t.Fatal("ticket for a revoked login token was accepted")
	}

	service.tokenRevoked = func(context.Context, string) bool { return false }
	entity.UserID = bson.NewObjectID()
	wrongOwner, err := createTerminalTicket(state, owner, entityID, false, token, claims, time.Now())
	if err != nil {
		t.Fatal(err)
	}
	if _, ok := service.consumeTerminalTicket(context.Background(), wrongOwner.Ticket); ok {
		t.Fatal("ticket was accepted after entity ownership changed")
	}
}

func TestTerminalTicketCannotOpenAnotherEntityURL(t *testing.T) {
	previous, err := config.DefaultSettings()
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = config.LoadSettings(previous) })
	if err := config.LoadSettings(map[string]any{"ConsoleOrigins": "https://peo.example"}); err != nil {
		t.Fatal(err)
	}
	owner := bson.NewObjectID()
	entityID := bson.NewObjectID()
	state := &terminalSessions{tickets: map[string]terminalTicket{}, active: map[[32]byte]map[string]context.CancelFunc{}}
	service := ConsoleService{
		terminalState: state,
		loadUser:      func(context.Context, bson.ObjectID) (*models.User, error) { return &models.User{ID: owner}, nil },
		loadEntity: func(context.Context, bson.ObjectID) (*models.WareEntity, error) {
			return &models.WareEntity{ID: entityID, UserID: owner}, nil
		},
		tokenRevoked: func(context.Context, string) bool { return false },
	}
	claims := &auth.Claims{ID: "jti-2", Expires: time.Now().Add(time.Hour)}
	ticket, err := createTerminalTicket(state, owner, entityID, false, "another-token", claims, time.Now())
	if err != nil {
		t.Fatal(err)
	}
	_, err = service.ConnectTerminal(context.Background(), bson.NewObjectID(), ticket.Ticket, "https://peo.example")
	var apiError *apierr.Error
	if !errors.As(err, &apiError) || apiError.Code != apierr.CodeForbidden {
		t.Fatalf("wrong entity URL error = %v, want forbidden", err)
	}
}

func TestBackupBelongsToCurrentServerList(t *testing.T) {
	backups := []pterodactyl.BridgeBackup{{UUID: "server-a-backup"}}
	if !backupBelongsToServer(backups, "server-a-backup") {
		t.Fatal("backup from the authorized server was not found")
	}
	if backupBelongsToServer(backups, "server-b-backup") {
		t.Fatal("backup from another server was accepted")
	}
}

func TestConsoleFileActionValidatesPathsAndModes(t *testing.T) {
	copyPayload := map[string]any{"location": "world/level.dat"}
	if err := validateFileAction("copy", copyPayload); err != nil {
		t.Fatalf("copy payload without root rejected: %v", err)
	}
	if copyPayload["location"] != "/world/level.dat" {
		t.Fatalf("copy location = %v, want normalized source path", copyPayload["location"])
	}

	valid := map[string]any{
		"root":  "/plugins/../world",
		"files": []any{map[string]any{"file": "world/level.dat", "mode": "755"}},
	}
	if err := validateFileAction("chmod", valid); err == nil {
		t.Fatal("traversal path was accepted")
	}
	valid = map[string]any{
		"root":  "/world",
		"files": []any{map[string]any{"file": "world/level.dat", "mode": "755"}},
	}
	if err := validateFileAction("chmod", valid); err != nil {
		t.Fatalf("valid chmod payload rejected: %v", err)
	}
	if valid["root"] != "/world" {
		t.Fatalf("root path = %v, want normalized path", valid["root"])
	}
	badMode := map[string]any{
		"root":  "/world",
		"files": []any{map[string]any{"file": "world/level.dat", "mode": "888"}},
	}
	if err := validateFileAction("chmod", badMode); err == nil {
		t.Fatal("invalid octal file mode was accepted")
	}
}

func TestLogoutCancelsRegisteredTerminalSession(t *testing.T) {
	token := "session-token"
	hash := tokenDigest(token)
	ctx, cancel := context.WithCancel(context.Background())
	id := RegisterTerminal(hash, cancel)
	defer UnregisterTerminal(hash, id)
	RevokeTerminalSessions(token)
	select {
	case <-ctx.Done():
	default:
		t.Fatal("session context was not cancelled")
	}
}
