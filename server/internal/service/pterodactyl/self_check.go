package pterodactyl

import (
	"context"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/email"
	"github.com/minoic/peo/server/internal/service/message"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// GraceDays is how long an expired server keeps running before it is eligible
// for destruction. It is stored per product as DeleteDuration; this constant is
// only the fallback for records written before that field existed.
const GraceDays = 10

// GracePeriod returns the grace window of a server record, falling back to
// GraceDays when the product can no longer be resolved.
func GracePeriod(ctx context.Context, e *models.WareEntity) time.Duration {
	spec, err := store.Spec.ByID(ctx, e.SpecID)
	if err != nil || spec.DeleteDuration <= 0 {
		return GraceDays * 24 * time.Hour
	}
	return spec.DeleteDuration
}

// CheckServers is the five-minute sweep over every provisioned server.
//
// Four things are decided here, in this order:
//
//   - a server whose owner already confirmed deletion and whose expiry has not
//     been renewed is destroyed;
//   - an expired server is suspended and its owner is told to renew;
//   - a server that has been expired for longer than the grace period is put on
//     the deletion list for an administrator to confirm;
//   - a server that was renewed is unsuspended and removed from that list.
//
// The legacy implementation ignored the per-product DeleteDuration and used a
// hard coded ten days for every product; it also suspended a server using the
// server's own external id rather than the id the record was created with, which
// only worked by accident. Both are handled correctly now.
func CheckServers(ctx context.Context) {
	entities, err := store.Entity.All(ctx)
	if err != nil {
		glgf.Error("pterodactyl: cannot list server records: ", err)
		return
	}
	cli := ClientFromConf()
	now := time.Now()

	for i := range entities {
		e := &entities[i]
		grace := GracePeriod(ctx, e)
		expired := e.ValidDate.Before(now)
		tooLate := e.ValidDate.Add(grace).Before(now)

		switch {
		case expired && tooLate && e.DeleteStatus == 2:
			// An administrator confirmed the deletion: destroy the server.
			if err := cli.DeleteServer(ctx, e.ServerExternalID); err != nil {
				glgf.Error("pterodactyl: cannot delete server ", e.ServerExternalID, ": ", err)
				continue
			}
			if err := store.Entity.Delete(ctx, e.ID); err != nil {
				glgf.Error("pterodactyl: cannot remove deleted server record ", e.ID.Hex(), ": ", err)
				continue
			}
			_ = store.DeleteConfirm.DeleteByWare(ctx, e.ID)
			glgf.Info("pterodactyl: destroyed server ", e.ServerExternalID)

		case expired && tooLate && e.DeleteStatus == 0:
			// Past the grace window: ask an administrator to confirm.
			if err := store.DeleteConfirm.Create(ctx, &models.DeleteConfirm{WareID: e.ID}); err != nil {
				glgf.Error("pterodactyl: cannot open delete confirmation: ", err)
				continue
			}
			if err := store.Entity.SetDeleteStatus(ctx, e.ID, 1); err != nil {
				glgf.Error("pterodactyl: cannot record delete status: ", err)
				continue
			}
			glgf.Info("pterodactyl: server ", e.ServerExternalID, " is awaiting delete confirmation")

		case expired:
			// Inside the grace window: suspend once and notify the owner.
			suspendAndNotify(ctx, cli, e)

		case e.DeleteStatus != 0:
			// Renewed: undo the deletion state and lift the suspension.
			if err := store.Entity.SetDeleteStatus(ctx, e.ID, 0); err != nil {
				glgf.Error("pterodactyl: cannot clear delete status: ", err)
			}
			if err := store.DeleteConfirm.DeleteByWare(ctx, e.ID); err != nil {
				glgf.Error("pterodactyl: cannot remove delete confirmation: ", err)
			}
			if err := cli.UnsuspendServer(ctx, e.ServerExternalID); err != nil {
				glgf.Error("pterodactyl: cannot unsuspend renewed server ", e.ServerExternalID, ": ", err)
			} else {
				glgf.Info("pterodactyl: unsuspended renewed server ", e.ServerExternalID)
			}
		}
	}
}

// suspendAndNotify suspends an expired server and messages its owner. A server
// that is already suspended is left alone, so the owner is mailed once rather
// than every five minutes.
func suspendAndNotify(ctx context.Context, cli *Client, e *models.WareEntity) {
	server, err := cli.GetServer(ctx, e.ServerExternalID)
	if err != nil {
		glgf.Warn("pterodactyl: cannot inspect server ", e.ServerExternalID, ": ", err)
		message.SendToAdmins(ctx, message.Compose(
			"server record ", e.ServerExternalID, " could not be found on the panel: ", err.Error()))
		return
	}
	if server.Suspended {
		return
	}
	if err := cli.SuspendServer(ctx, e.ServerExternalID); err != nil {
		glgf.Error("pterodactyl: cannot suspend expired server ", e.ServerExternalID, ": ", err)
		return
	}
	glgf.Info("pterodactyl: suspended expired server ", e.ServerExternalID)

	owner, err := store.User.ByID(ctx, e.UserID)
	if err != nil {
		message.SendToAdmins(ctx, message.Compose(
			"server ", e.ServerExternalID, " belongs to a user that no longer exists"))
		return
	}
	message.SendAdmin(ctx, owner.ID, message.Compose(
		"Your server <", e.ServerExternalID, "> has been suspended because it expired. Please renew it as soon as possible."))
	if err := email.SendAnyEmail(owner.Email, "Your server <", e.ServerExternalID,
		"> has expired and been suspended. Renew it in time to keep your service and data."); err != nil {
		glgf.Error("pterodactyl: cannot mail expiry notice to ", owner.Email, ": ", err)
	}
}

// ConfirmDelete destroys a server after an administrator approved its deletion.
func ConfirmDelete(ctx context.Context, entityID bson.ObjectID) error {
	e, err := store.Entity.ByID(ctx, entityID)
	if err != nil {
		return err
	}
	if err := ClientFromConf().DeleteServer(ctx, e.ServerExternalID); err != nil {
		return err
	}
	if err := store.Entity.Delete(ctx, entityID); err != nil {
		return err
	}
	return store.DeleteConfirm.DeleteByWare(ctx, entityID)
}

// RejectDelete cancels a pending deletion, leaving the server suspended but
// intact so the owner can still renew it.
func RejectDelete(ctx context.Context, entityID bson.ObjectID) error {
	if err := store.DeleteConfirm.DeleteByWare(ctx, entityID); err != nil {
		return err
	}
	return store.Entity.SetDeleteStatus(ctx, entityID, 0)
}
