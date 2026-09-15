package service

import (
	"context"
	"sync"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/message"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/service/status"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

const (
	// renewCooldown stops a double submit from spending two activation codes in
	// the time the first request is still in flight.
	renewCooldown = 10 * time.Second
	// reinstallCooldown matches the legacy limit of one reinstall per user per
	// ten seconds.
	reinstallCooldown = 10 * time.Second
)

// ServerService owns the life cycle of an already provisioned server.
type ServerService struct {
	// cache holds the latest Minecraft probe answer per host. Handlers read it,
	// the cron writes it.
	cache *Cache
}

// Servers is the default ServerService.
var Servers = ServerService{cache: NewCache()}

// entityFor loads a server record and checks that the caller may act on it.
// Administrators can act on any record; everyone else only on their own.
func entityFor(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) (*models.WareEntity, error) {
	e, err := store.Entity.ByID(ctx, entityID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "server not found", err)
	}
	if e.UserID != userID && !isAdmin {
		return nil, apierr.Fail(apierr.CodeForbidden, "this server belongs to another account")
	}
	return e, nil
}

// List returns the servers a user may see, with the panel state attached. An
// administrator sees every record, matching the legacy console.
func (ServerService) List(ctx context.Context, userID bson.ObjectID, isAdmin bool) ([]models.WareEntity, error) {
	if isAdmin {
		return store.Entity.All(ctx)
	}
	return store.Entity.ByUser(ctx, userID)
}

// ByID returns one server record owned by the caller.
func (ServerService) ByID(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) (*models.WareEntity, error) {
	return entityFor(ctx, entityID, userID, isAdmin)
}

// Status describes the live state of a server on the panel plus the Minecraft
// probe result, which is what the console actually renders.
type Status struct {
	EntityID     string    `json:"entityId"`
	ExternalID   string    `json:"externalId"`
	HostName     string    `json:"hostName"`
	ValidDate    time.Time `json:"validDate"`
	DeleteStatus int       `json:"deleteStatus"`
	Suspended    bool      `json:"suspended"`
	Identifier   string    `json:"identifier,omitempty"`
	PanelName    string    `json:"panelName,omitempty"`

	Online      bool   `json:"online"`
	Version     string `json:"version,omitempty"`
	Motd        string `json:"motd,omitempty"`
	PlayerCount int    `json:"playerCount"`
	PlayerMax   int    `json:"playerMax"`

	Probing bool `json:"probing"`
}

// probeCacheTTL bounds how long a Minecraft answer is reused. The legacy console
// pinged every address once per request, which made a five server page wait for
// five sequential TCP timeouts; the answer is now shared with the background
// sweep so a page render never blocks on a dead server.
const probeCacheTTL = 30 * time.Second

// probeResult is one cached Minecraft status answer.
type probeResult struct {
	Online      bool
	Version     string
	Motd        string
	PlayerCount int
	PlayerMax   int
	At          time.Time
}

// Status reads the panel state of every server of a user. Panel failures are
// not fatal: the record is still returned with Suspended unset, so the console
// can render the expiry date even when the panel is down.
func (ServerService) Status(ctx context.Context, userID bson.ObjectID, isAdmin bool) ([]Status, error) {
	entities, err := Servers.List(ctx, userID, isAdmin)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot list servers", err)
	}
	cli := pterodactyl.ClientFromConf()
	out := make([]Status, 0, len(entities))
	for i := range entities {
		e := &entities[i]
		s := Status{
			EntityID:     e.ID.Hex(),
			ExternalID:   e.ServerExternalID,
			HostName:     e.HostName,
			ValidDate:    e.ValidDate,
			DeleteStatus: e.DeleteStatus,
		}
		server, err := cli.GetServer(ctx, e.ServerExternalID)
		if err != nil {
			glgf.Warn("server: cannot read panel state for " + e.ServerExternalID + ": " + err.Error())
		} else {
			s.Suspended = server.Suspended
			s.Identifier = server.Identifier
			s.PanelName = server.Name
		}
		s.applyProbe(Servers.cache, e.HostName)
		out = append(out, s)
	}
	return out, nil
}

// applyProbe copies the cached Minecraft answer onto a status row. A host that
// has never been probed is reported as Probing rather than offline, because "we
// have not asked yet" and "the server is down" are different states and the
// console shows them differently.
func (s *Status) applyProbe(c *Cache, host string) {
	pr, ok := c.probeFor(host)
	if !ok {
		s.Probing = true
		return
	}
	s.Online = pr.Online
	s.Version = pr.Version
	s.Motd = pr.Motd
	s.PlayerCount = pr.PlayerCount
	s.PlayerMax = pr.PlayerMax
}

// probeWorkers bounds how many servers are pinged at the same time. Minecraft
// pings open raw TCP connections, and a site with hundreds of servers must not
// exhaust the file descriptor table on every sweep.
const probeWorkers = 16

// ProbeAll refreshes the Minecraft status of every server and, for each one that
// answers, credits its owner with the elapsed interval. It is the port of the
// legacy "ping every server every 30 seconds and add uptime" cron job.
//
// The elapsed time is passed in by the caller instead of being hard-coded so the
// credited duration always matches the real interval between two sweeps, even
// when a sweep overruns its schedule.
func (ServerService) ProbeAll(ctx context.Context, elapsed time.Duration) {
	entities, err := store.Entity.All(ctx)
	if err != nil {
		glgf.Error("server: cannot list servers to probe: ", err)
		return
	}
	sem := make(chan struct{}, probeWorkers)
	var wg sync.WaitGroup
	for i := range entities {
		e := entities[i]
		if e.HostName == "" {
			continue
		}
		wg.Add(1)
		sem <- struct{}{}
		go func() {
			defer wg.Done()
			defer func() { <-sem }()
			Servers.probe(ctx, e.HostName, e.UserID, elapsed)
		}()
	}
	wg.Wait()
}

// probe pings one address, stores the answer and credits uptime on success. The
// uptime write happens here rather than in the caller because only the probe
// knows whether the server was reachable.
func (ServerService) probe(ctx context.Context, host string, userID bson.ObjectID, elapsed time.Duration) {
	pong, err := status.Ping(host)
	if err != nil {
		Servers.cache.putProbe(host, probeResult{Online: false, At: time.Now()})
		return
	}
	// A zero protocol version is what the panel returns for a server that is not
	// actually listening; the legacy code treated it as offline.
	online := pong.Version.Protocol != 0
	result := probeResult{
		Online:      online,
		Version:     pong.Version.Name,
		Motd:        motdOf(pong),
		PlayerCount: pong.Players.Online,
		PlayerMax:   pong.Players.Max,
		At:          time.Now(),
	}
	Servers.cache.putProbe(host, result)
	if !online || elapsed <= 0 {
		return
	}
	if err := store.User.AddUpTime(ctx, userID, elapsed); err != nil {
		glgf.Error("server: cannot credit uptime for ", host, ": ", err)
	}
}

// motdOf extracts the description text. A Minecraft MOTD is either a plain
// string or a chat component tree; the modern protocol usually sends the legacy
// text field, so that is preferred and the translate key is the fallback.
func motdOf(pong *status.Pong) string {
	if pong.Description.Text != "" {
		return pong.Description.Text
	}
	return pong.Description.Translate
}

// Renew redeems an activation code against a server. The new expiry is counted
// from the later of the current expiry and now, so renewing early never loses
// the remaining time and renewing late never counts the idle period twice.
func (ServerService) Renew(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool, keyString string) error {
	e, err := entityFor(ctx, entityID, userID, isAdmin)
	if err != nil {
		return err
	}
	limitKey := "RENEW" + e.ID.Hex()
	if redis.Limited(ctx, limitKey) {
		return apierr.Fail(apierr.CodeRateLimited, "please do not renew so often")
	}
	key, err := store.Key.ByString(ctx, keyString)
	if err != nil {
		return apierr.Wrap(apierr.CodeInvalidKey, "activation code not found", err)
	}
	if key.SpecID != e.SpecID {
		return apierr.Fail(apierr.CodeInvalidKey, "the activation code is for another product")
	}
	spec, err := store.Spec.ByID(ctx, key.SpecID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}

	redis.Limit(ctx, limitKey, renewCooldown)
	// The code is consumed up front and restored if the write fails, so two
	// concurrent requests cannot both redeem it. Redis also guards this, but
	// that guard is advisory: it can expire between the check and the write.
	if err := store.Key.Delete(ctx, key.ID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot consume the activation code", err)
	}
	base := e.ValidDate
	if time.Now().After(base) {
		base = time.Now()
	}
	if err := store.Entity.SetValidDate(ctx, e.ID, base.Add(spec.ValidDuration)); err != nil {
		restoreKey(ctx, key)
		return apierr.Wrap(apierr.CodeInternal, "cannot update the server record", err)
	}
	if err := store.Entity.SetDeleteStatus(ctx, e.ID, 0); err != nil {
		restoreKey(ctx, key)
		return apierr.Wrap(apierr.CodeInternal, "cannot update the server record", err)
	}
	// The deletion notice, if one was pending, is now void.
	if err := store.DeleteConfirm.DeleteByWare(ctx, e.ID); err != nil {
		glgf.Error("server: cannot clear delete confirmation: " + err.Error())
	}
	syncPanelExpiry(ctx, e, base.Add(spec.ValidDuration))
	glgf.Info("server: renewed " + e.ServerExternalID)
	return nil
}

// RenewWithBalance extends a server by one month, paid from the balance.
func (ServerService) RenewWithBalance(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) error {
	e, err := entityFor(ctx, entityID, userID, isAdmin)
	if err != nil {
		return err
	}
	u, err := store.User.ByID(ctx, e.UserID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	spec, err := store.Spec.ByID(ctx, e.SpecID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	cost := spec.PricePerMonth * uint(100-spec.Discount) / 100
	if cost > u.Balance {
		return apierr.Fail(apierr.CodeInsufficientBalance, "your balance is not enough")
	}
	if err := store.User.AddBalance(ctx, u.ID, -int64(cost)); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot charge the balance", err)
	}
	base := e.ValidDate
	if time.Now().After(base) {
		base = time.Now()
	}
	newDate := base.AddDate(0, 1, 0)
	if err := store.Entity.SetValidDate(ctx, e.ID, newDate); err != nil {
		// Refund: the balance was taken but the server was not extended.
		if refundErr := store.User.AddBalance(ctx, u.ID, int64(cost)); refundErr != nil {
			glgf.Error("server: cannot refund renewed balance: " + refundErr.Error())
		}
		return apierr.Wrap(apierr.CodeInternal, "cannot update the server record", err)
	}
	if err := store.Entity.SetDeleteStatus(ctx, e.ID, 0); err != nil {
		glgf.Error("server: cannot clear delete status: " + err.Error())
	}
	if err := store.DeleteConfirm.DeleteByWare(ctx, e.ID); err != nil {
		glgf.Error("server: cannot clear delete confirmation: " + err.Error())
	}
	syncPanelExpiry(ctx, e, newDate)
	return nil
}

// Reinstall swaps the egg of a server and re-runs its install script. The egg
// must be offered by the product's nest; without that check a customer could
// select an egg from a different nest and break their own container.
func (ServerService) Reinstall(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool, eggID int) error {
	e, err := entityFor(ctx, entityID, userID, isAdmin)
	if err != nil {
		return err
	}
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	limitKey := "REINSTALL" + u.Name
	if redis.Limited(ctx, limitKey) {
		return apierr.Fail(apierr.CodeRateLimited, "please do not reinstall so often")
	}
	spec, err := store.Spec.ByID(ctx, e.SpecID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	eggs, err := pterodactyl.ClientFromConf().GetAllEggs(ctx, spec.Nest)
	if err != nil {
		return apierr.Wrap(apierr.CodePterodactylError, "cannot list the available eggs", err)
	}
	allowed := false
	for _, egg := range eggs {
		if egg.Id == eggID {
			allowed = true
			break
		}
	}
	if !allowed {
		return apierr.Fail(apierr.CodeValidationFailed, "the selected integration does not belong to this server")
	}
	cli := pterodactyl.ClientFromConf()
	if err := cli.UpdateServerStartup(ctx, e.ServerExternalID, eggID); err != nil {
		return apierr.Wrap(apierr.CodePterodactylError, "cannot update the server startup", err)
	}
	if err := cli.ReinstallServer(ctx, e.ServerExternalID); err != nil {
		return apierr.Wrap(apierr.CodePterodactylError, "cannot reinstall the server", err)
	}
	redis.Limit(ctx, limitKey, reinstallCooldown)
	return nil
}

// Delete confirms the destruction of a server. It is only reachable once an
// administrator approved the deletion, so it never removes a live server.
func (ServerService) Delete(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) error {
	e, err := entityFor(ctx, entityID, userID, isAdmin)
	if err != nil {
		return err
	}
	if e.DeleteStatus != 2 {
		return apierr.Fail(apierr.CodeForbidden, "the server has not been approved for deletion")
	}
	return apierr.AsError(pterodactyl.ConfirmDelete(ctx, e.ID))
}

// RequestDelete lets an owner ask for their server to be destroyed. The request
// only becomes a deletion after an administrator confirms it, so a mistake is
// still recoverable.
func (ServerService) RequestDelete(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) error {
	e, err := entityFor(ctx, entityID, userID, isAdmin)
	if err != nil {
		return err
	}
	if e.DeleteStatus == 0 {
		if err := store.DeleteConfirm.Create(ctx, &models.DeleteConfirm{WareID: e.ID}); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot record the deletion request", err)
		}
		if err := store.Entity.SetDeleteStatus(ctx, e.ID, 1); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot record the deletion request", err)
		}
	}
	return nil
}

// syncPanelExpiry rewrites the panel description so the date the customer sees
// in the Pterodactyl console matches the one this application enforces. A
// failure here is cosmetic and is reported to an administrator.
func syncPanelExpiry(ctx context.Context, e *models.WareEntity, validDate time.Time) {
	cli := pterodactyl.ClientFromConf()
	// Legacy warned the customer on this branch too, before it even tried to
	// rewrite the description (user_console_controller.go:267): if the panel
	// cannot be read, the date shown in the console is stale either way.
	withoutDescription := message.Compose(
		"Your server <", e.ServerExternalID, "> was renewed, but its expiry date could not be updated in the Pterodactyl Panel")
	server, err := cli.GetServer(ctx, e.ServerExternalID)
	if err != nil {
		glgf.Warn("server: cannot update panel description for " + e.ServerExternalID + ": " + err.Error())
		message.SendAdmin(ctx, e.UserID, withoutDescription)
		return
	}
	if err := cli.UpdateServerDetail(ctx, e.ServerExternalID, pterodactyl.PostUpdateDetails{
		UserID:      server.UserId,
		ServerName:  server.Name,
		Description: ExpiryLabel + validDate.Format(dateOnly),
		ExternalID:  server.ExternalId,
	}); err != nil {
		glgf.Warn("server: cannot sync expiry " + e.ServerExternalID + ": " + err.Error())
		message.SendAdmin(ctx, e.UserID, withoutDescription)
		return
	}
	// A renewed server must start working again even if it was suspended.
	if err := cli.UnsuspendServer(ctx, e.ServerExternalID); err != nil {
		glgf.Warn("server: cannot unsuspend renewed server " + e.ServerExternalID + ": " + err.Error())
		message.SendAdmin(ctx, e.UserID, message.Compose(
			"Your server <", e.ServerExternalID, "> was renewed but could not be unsuspended; please retry shortly"))
	}
}

// restoreKey puts an activation code back after a failed renewal.
func restoreKey(ctx context.Context, k *models.WareKey) {
	if err := store.Key.Create(ctx, k); err != nil {
		glgf.Error("server: cannot restore activation code " + k.KeyString + ": " + err.Error())
	}
}
