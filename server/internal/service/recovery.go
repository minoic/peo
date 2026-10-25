package service

import (
	"context"
	"errors"
	"math"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
)

// RecoverOperations completes balance renewals whose process stopped after
// reserving the entity but before recording the resulting expiry.
func RecoverOperations(ctx context.Context) {
	recoverAlipaySettlements(ctx)
	recoverRechargeKeys(ctx)
	entities, err := store.Entity.PendingBalanceRenewals(ctx)
	if err != nil {
		glgf.Error("recovery: cannot list pending balance renewals: ", err)
		return
	}
	for i := range entities {
		e := &entities[i]
		op := e.BalanceRenewal
		if op == nil || op.ID == "" || op.Amount > math.MaxInt64 {
			glgf.Error("recovery: invalid balance renewal record for ", e.ID.Hex())
			continue
		}
		var err error
		if op.Amount > 0 {
			_, err = store.User.ApplyBalanceOnce(ctx, op.UserID, "server-renew:"+op.ID, -int64(op.Amount))
		}
		if errors.Is(err, store.ErrInsufficientBalance) {
			canceled, applied, cancelErr := store.User.CancelBalanceOperation(ctx, op.UserID, "server-renew:"+op.ID, op.Amount)
			if cancelErr != nil {
				glgf.Error("recovery: cannot resolve unfunded renewal ", op.ID, ": ", cancelErr)
				continue
			}
			if applied {
				err = nil
			} else if canceled {
				if cancelErr := store.Entity.CancelBalanceRenewal(ctx, e.ID, op.ID); cancelErr != nil {
					glgf.Error("recovery: cannot cancel unfunded renewal ", op.ID, ": ", cancelErr)
				}
				continue
			} else {
				continue
			}
		}
		if errors.Is(err, store.ErrBalanceOperationCanceled) {
			if cancelErr := store.Entity.CancelBalanceRenewal(ctx, e.ID, op.ID); cancelErr != nil {
				glgf.Error("recovery: cannot clear canceled renewal ", op.ID, ": ", cancelErr)
			}
			continue
		}
		if err != nil {
			glgf.Error("recovery: cannot apply balance renewal ", op.ID, ": ", err)
			continue
		}
		if err := store.Entity.FinishBalanceRenewal(ctx, e.ID, op.ID, op.ValidDate); err != nil {
			glgf.Error("recovery: cannot finalize balance renewal ", op.ID, ": ", err)
			continue
		}
		e.ValidDate = op.ValidDate
		syncPanelExpiry(ctx, e, op.ValidDate, false)
	}
	recoverKeyRenewals(ctx)
	orders, err := store.Order.PendingProvisions(ctx)
	if err != nil {
		glgf.Error("recovery: cannot list pending order provisions: ", err)
	} else {
		for i := range orders {
			order := &orders[i]
			if order.Provision == nil {
				continue
			}
			if err := runProvision(ctx, order, order.Provision); err != nil {
				glgf.Error("recovery: cannot finish order provision ", order.ID.Hex(), ": ", err)
			}
		}
	}
	keyOrders, err := store.Order.PendingProvisionKeyCleanup(ctx)
	if err != nil {
		glgf.Error("recovery: cannot list completed key orders: ", err)
	} else {
		for i := range keyOrders {
			order := &keyOrders[i]
			if order.Provision == nil {
				continue
			}
			if err := consumeProvisionKey(ctx, order, order.Provision); err != nil {
				glgf.Error("recovery: cannot consume key for completed order ", order.ID.Hex(), ": ", err)
			}
		}
	}
	pterodactyl.RecoverPendingDeletes(ctx)
}

func recoverAlipaySettlements(ctx context.Context) {
	logs, err := store.RechargeLog.PendingSettlements(ctx, time.Now().Add(-time.Minute))
	if err != nil {
		glgf.Error("recovery: cannot list pending Alipay settlements: ", err)
		return
	}
	for i := range logs {
		log := &logs[i]
		claimed, err := store.RechargeLog.ClaimSettlement(ctx, log.ID, time.Now())
		if err != nil || !claimed {
			if err != nil {
				glgf.Error("recovery: cannot claim Alipay settlement ", log.OutTradeNo, ": ", err)
			}
			continue
		}
		user, err := store.User.ByID(ctx, log.UserID)
		if err != nil {
			glgf.Error("recovery: cannot load Alipay settlement user ", log.UserID.Hex(), ": ", err)
			continue
		}
		if err := settleAlipayLog(ctx, log, user); err != nil {
			glgf.Error("recovery: cannot finish Alipay settlement ", log.OutTradeNo, ": ", err)
		}
	}
}

func recoverRechargeKeys(ctx context.Context) {
	keys, err := store.RKey.ClaimedBefore(ctx, time.Now().Add(-2*time.Minute))
	if err != nil {
		glgf.Error("recovery: cannot list claimed recharge keys: ", err)
		return
	}
	for i := range keys {
		key := &keys[i]
		if key.ClaimID != "recharge-key:"+key.ID.Hex() {
			continue
		}
		delta, err := balanceDelta(key.Balance)
		if err != nil {
			glgf.Error("recovery: invalid recharge key amount ", key.ID.Hex(), ": ", err)
			continue
		}
		if _, err := store.User.ApplyBalanceOnce(ctx, key.ClaimUser, key.ClaimID, delta); err != nil {
			glgf.Error("recovery: cannot apply recharge key ", key.ID.Hex(), ": ", err)
			continue
		}
		if err := store.RKey.Delete(ctx, key.ID); err != nil {
			glgf.Error("recovery: cannot delete consumed recharge key ", key.ID.Hex(), ": ", err)
		}
	}
}

func recoverKeyRenewals(ctx context.Context) {
	now := time.Now()
	entities, err := store.Entity.PendingKeyRenewals(ctx, now)
	if err != nil {
		glgf.Error("recovery: cannot list pending key renewals: ", err)
		return
	}
	for i := range entities {
		entity := &entities[i]
		if entity.KeyRenewal == nil {
			continue
		}
		op := *entity.KeyRenewal
		op.LeaseID = models.NewID().Hex()
		op.LeaseUntil = now.Add(2 * time.Minute)
		op.UpdatedAt = now
		started, err := store.Entity.BeginKeyRenewal(ctx, entity.ID, entity.ValidDate, op, now)
		if err != nil || !started {
			if err != nil {
				glgf.Error("recovery: cannot acquire key renewal ", op.ID, ": ", err)
			}
			continue
		}
		key, err := store.Key.ByID(ctx, op.KeyID)
		if err != nil {
			if store.IsNotFound(err) {
				if cancelErr := store.Entity.CancelKeyRenewal(ctx, entity.ID, op); cancelErr != nil {
					glgf.Error("recovery: cannot cancel renewal with missing key ", op.ID, ": ", cancelErr)
				}
			} else {
				glgf.Error("recovery: cannot read key for renewal ", op.ID, ": ", err)
			}
			continue
		}
		claimID := op.ID
		if _, err := store.Key.Claim(ctx, key.ID, claimID, op.UserID, key.SpecID, op.CreatedAt); err != nil {
			if store.IsNotFound(err) {
				if cancelErr := store.Entity.CancelKeyRenewal(ctx, entity.ID, op); cancelErr != nil {
					glgf.Error("recovery: cannot cancel renewal with unavailable key ", op.ID, ": ", cancelErr)
				}
			} else {
				glgf.Error("recovery: cannot confirm key claim for renewal ", op.ID, ": ", err)
			}
			continue
		}
		applied, alreadyApplied, err := store.Entity.CompleteKeyRenewal(ctx, entity.ID, op)
		if err != nil || (!applied && !alreadyApplied) {
			if err != nil {
				glgf.Error("recovery: cannot complete key renewal ", op.ID, ": ", err)
			}
			continue
		}
		if err := store.Key.Delete(ctx, key.ID); err != nil {
			glgf.Error("recovery: cannot delete consumed activation code: ", err)
			continue
		}
		entity.ValidDate = op.ValidDate
		syncPanelExpiry(ctx, entity, op.ValidDate, true)
	}

	// A crash after the entity receipt was committed but before key deletion is
	// safe to finish without reopening the renewal effect.
	keys, err := store.Key.ClaimedBefore(ctx, now.Add(-2*time.Minute))
	if err != nil {
		glgf.Error("recovery: cannot list claimed activation codes: ", err)
		return
	}
	for i := range keys {
		key := &keys[i]
		if !strings.HasPrefix(key.ClaimID, "renew:") {
			continue
		}
		parts := strings.Split(key.ClaimID, ":")
		if len(parts) != 3 {
			continue
		}
		entityID, err := models.ObjectIDFromHex(parts[1])
		if err != nil {
			continue
		}
		entity, err := store.Entity.ByID(ctx, entityID)
		if err != nil {
			continue
		}
		for _, keyID := range entity.RenewedKeyIDs {
			if keyID == key.ID {
				if err := store.Key.Delete(ctx, key.ID); err != nil {
					glgf.Error("recovery: cannot delete consumed activation code: ", err)
				}
				break
			}
		}
	}
}
