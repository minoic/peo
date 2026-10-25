// Package service holds the business rules that used to live inside the Beego
// controllers.
package service

import (
	"context"
	"encoding/json"
	"errors"
	"math"
	"math/rand"
	"strconv"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/message"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// ExpiryLabel prefixes the panel description that tells a customer when their
// server expires. The panel shows it verbatim in its own console.
const ExpiryLabel = "Expiry: "

// dateOnly is the format used for the panel description and the expiry mail.
const dateOnly = "2006-01-02"

// day is a convenience for the duration literals below.
const day = 24 * time.Hour

// PendingOrderLifetime is the payment window for an order.
const PendingOrderLifetime = models.OrderPaymentWindow

// OrderService owns the purchase flow: pricing, payment and provisioning.
type OrderService struct{}

// Order is the default OrderService.
var Order = OrderService{}

// Pricing is the result of evaluating a product's duration and discount.
type Pricing struct {
	OriginPrice uint `json:"originPrice"`
	FinalPrice  uint `json:"finalPrice"`
}

// PriceFor reproduces the legacy pricing table exactly.
//
// A three day product is the trial: it always costs one unit whatever the
// monthly price says. Thirty, ninety and three hundred sixty five day products
// are priced from PricePerMonth and, when TotalDiscount is on, reduced by the
// product's discount percentage. Any other duration prices at zero -- that is
// inherited behaviour, not an oversight, and the storefront only ever offers
// products whose duration is one of the four.
func PriceFor(spec *models.WareSpec) Pricing {
	discount := uint(100 - spec.Discount)
	applyDiscount := config.Bool("TotalDiscount")
	switch spec.ValidDuration {
	case 3 * day:
		return Pricing{OriginPrice: 1, FinalPrice: 1}
	case 30 * day:
		if applyDiscount {
			return Pricing{spec.PricePerMonth, uint(0.01 * float32(discount*spec.PricePerMonth))}
		}
		return Pricing{spec.PricePerMonth, spec.PricePerMonth}
	case 90 * day:
		if applyDiscount {
			return Pricing{spec.PricePerMonth * 3, uint(0.03 * float32(discount*spec.PricePerMonth))}
		}
		return Pricing{spec.PricePerMonth * 3, spec.PricePerMonth * 3}
	case 365 * day:
		if applyDiscount {
			return Pricing{spec.PricePerMonth * 12, uint(0.12 * float32(discount*spec.PricePerMonth))}
		}
		return Pricing{spec.PricePerMonth * 12, spec.PricePerMonth * 12}
	}
	return Pricing{}
}

// Create opens a pending order for a product.
func (OrderService) Create(ctx context.Context, specID, userID bson.ObjectID) (*models.Order, error) {
	spec, err := store.Spec.ByID(ctx, specID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	p := PriceFor(spec)
	o := &models.Order{
		SpecID:      spec.ID,
		UserID:      userID,
		OriginPrice: p.OriginPrice,
		FinalPrice:  p.FinalPrice,
	}
	if err := store.Order.Create(ctx, o); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot create order", err)
	}
	return o, nil
}

// Allocation is one free port on the node the ordered product is pinned to.
type Allocation struct {
	ID int `json:"id"`
	// Address is the `alias:port` label the customer picks from.
	Address string `json:"address"`
}

// Allocations lists the free ports a customer may bind their new server to. The
// node comes from the ordered product, and a product pinned to node 0 is placed
// on a random node at provisioning time, so its address list is the union of
// every node's free ports - the same set the legacy checkout page showed.
func (OrderService) Allocations(ctx context.Context, orderID bson.ObjectID) ([]Allocation, error) {
	o, err := store.Order.ByID(ctx, orderID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "order not found", err)
	}
	spec, err := store.Spec.ByID(ctx, o.SpecID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	cli := pterodactyl.ClientFromConf()
	nodeIDs := []int{spec.Node}
	if spec.Node == 0 {
		nodes, err := cli.GetAllNodes(ctx)
		if err != nil {
			return nil, apierr.Wrap(apierr.CodePterodactylError, "cannot list panel nodes", err)
		}
		nodeIDs = make([]int, 0, len(nodes))
		for i := range nodes {
			nodeIDs = append(nodeIDs, nodes[i].Id)
		}
	}
	out := []Allocation{}
	for _, nodeID := range nodeIDs {
		free, err := cli.GetAllocations(ctx, nodeID)
		if err != nil {
			return nil, apierr.Wrap(apierr.CodePterodactylError, "cannot list free ports", err)
		}
		for i := range free {
			out = append(out, Allocation{
				ID:      free[i].ID,
				Address: free[i].Alias + ":" + strconv.Itoa(free[i].Port),
			})
		}
	}
	return out, nil
}

// ByID returns an order the caller is allowed to see.
func (OrderService) ByID(ctx context.Context, orderID, userID bson.ObjectID, isAdmin bool) (*models.Order, error) {
	o, err := store.Order.ByID(ctx, orderID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "order not found", err)
	}
	if o.UserID != userID && !isAdmin {
		return nil, apierr.Fail(apierr.CodeForbidden, "this order belongs to another account")
	}
	if err := store.Order.CloseIfExpired(ctx, orderID, time.Now()); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot expire order", err)
	}
	o, err = store.Order.ByID(ctx, orderID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "order not found", err)
	}
	return o, nil
}

// ListByUser returns the orders of a user, newest first.
func (OrderService) ListByUser(ctx context.Context, userID bson.ObjectID) ([]models.Order, error) {
	if _, err := store.Order.CloseExpiredByUser(ctx, userID, time.Now()); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot expire orders", err)
	}
	return store.Order.ByUser(ctx, userID)
}

// PayWithKey redeems an activation code for an order and provisions the server.
// The code must belong to the same product and must not have expired. The code
// is only deleted once the server exists, so a failed provisioning leaves the
// customer able to try again.
func (OrderService) PayWithKey(ctx context.Context, orderID, userID bson.ObjectID, keyString string, allocationID int, hostName string) error {
	o, err := store.Order.ByID(ctx, orderID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "order not found", err)
	}
	if o.UserID != userID {
		return apierr.Fail(apierr.CodeForbidden, "this order belongs to another account")
	}
	if o.Paid {
		return apierr.Fail(apierr.CodeAlreadyPaid, "order is already paid")
	}
	if o.Closed {
		return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
	}
	if orderExpired(o, time.Now()) && (o.Provision == nil || o.Provision.State == "payment_failed") {
		if err := store.Order.CloseIfExpired(ctx, o.ID, time.Now()); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot close expired order", err)
		}
		return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
	}
	key, err := store.Key.ByString(ctx, keyString)
	if err != nil {
		return apierr.Wrap(apierr.CodeInvalidKey, "activation code not found", err)
	}
	claimID := "order:" + o.ID.Hex()
	if o.Provision != nil && o.Provision.State != "payment_failed" && o.Provision.PaymentMethod == "key" && o.Provision.KeyID == key.ID {
		claimID = o.Provision.ID
	}
	if (key.Exp.Before(time.Now()) && (key.ClaimID != claimID || key.ClaimUser != userID)) || key.SpecID != o.SpecID {
		return apierr.Fail(apierr.CodeInvalidKey, "activation code is not valid for this product")
	}
	if o.Provision != nil && o.Provision.State != "payment_failed" {
		if o.Provision.PaymentMethod != "key" || o.Provision.KeyID != key.ID || o.Provision.AllocationID != allocationID || o.Provision.CustomerHost != hostName {
			return apierr.Fail(apierr.CodeConflict, "order payment is already in progress")
		}
		return runProvision(ctx, o, o.Provision)
	}
	op, err := prepareProvision(ctx, o, "key", key.ID, allocationID, hostName)
	if err != nil {
		return err
	}
	claimed, err := store.Order.BeginProvision(ctx, o.ID, op)
	if err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot reserve order payment", err)
	}
	if !claimed {
		fresh, readErr := store.Order.ByID(ctx, o.ID)
		if readErr == nil && fresh.Provision != nil && fresh.Provision.ID == op.ID && fresh.Provision.PaymentMethod == "key" && fresh.Provision.KeyID == key.ID && fresh.Provision.AllocationID == allocationID && fresh.Provision.CustomerHost == hostName {
			op = fresh.Provision
		} else {
			if readErr == nil {
				if fresh.Closed {
					return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
				}
				if orderExpired(fresh, time.Now()) && (fresh.Provision == nil || fresh.Provision.State == "payment_failed") {
					if closeErr := store.Order.CloseIfExpired(ctx, o.ID, time.Now()); closeErr != nil {
						return apierr.Wrap(apierr.CodeInternal, "cannot close expired order", closeErr)
					}
					return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
				}
			}
			return apierr.Fail(apierr.CodeConflict, "order payment is already in progress")
		}
	}
	if err := runProvision(ctx, o, op); err != nil {
		return err
	}
	glgf.Info("order: activation code redeemed " + key.KeyString)
	message.SendAdmin(ctx, o.UserID, message.Compose("Your order #", o.ID.Hex(), " created its server; please confirm it in the control panel"))
	return nil
}

// PayWithBalance reserves the charge in the durable order operation before
// provisioning; recovery completes the same intent after a panel outage.
func (OrderService) PayWithBalance(ctx context.Context, orderID, userID bson.ObjectID, allocationID int, hostName string) error {
	o, err := store.Order.ByID(ctx, orderID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "order not found", err)
	}
	if o.UserID != userID {
		return apierr.Fail(apierr.CodeForbidden, "this order belongs to another account")
	}
	if o.Paid {
		return apierr.Fail(apierr.CodeAlreadyPaid, "order is already paid")
	}
	if o.Closed {
		return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
	}
	if orderExpired(o, time.Now()) && (o.Provision == nil || o.Provision.State == "payment_failed") {
		if err := store.Order.CloseIfExpired(ctx, o.ID, time.Now()); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot close expired order", err)
		}
		return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
	}
	if o.Provision != nil && o.Provision.State != "payment_failed" {
		if o.Provision.PaymentMethod != "balance" || o.Provision.AllocationID != allocationID || o.Provision.CustomerHost != hostName {
			return apierr.Fail(apierr.CodeConflict, "order payment is already in progress")
		}
		return runProvision(ctx, o, o.Provision)
	}
	if o.FinalPrice > math.MaxInt64 {
		return apierr.Fail(apierr.CodeValidationFailed, "order amount is invalid")
	}
	op, err := prepareProvision(ctx, o, "balance", bson.NilObjectID, allocationID, hostName)
	if err != nil {
		return err
	}
	claimed, err := store.Order.BeginProvision(ctx, o.ID, op)
	if err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot reserve order payment", err)
	}
	if !claimed {
		fresh, readErr := store.Order.ByID(ctx, o.ID)
		if readErr == nil && fresh.Provision != nil && fresh.Provision.ID == op.ID && fresh.Provision.PaymentMethod == "balance" && fresh.Provision.AllocationID == allocationID && fresh.Provision.CustomerHost == hostName {
			op = fresh.Provision
		} else {
			if readErr == nil {
				if fresh.Closed {
					return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
				}
				if orderExpired(fresh, time.Now()) && (fresh.Provision == nil || fresh.Provision.State == "payment_failed") {
					if closeErr := store.Order.CloseIfExpired(ctx, o.ID, time.Now()); closeErr != nil {
						return apierr.Wrap(apierr.CodeInternal, "cannot close expired order", closeErr)
					}
					return apierr.Fail(apierr.CodeConflict, "order has expired and is closed")
				}
			}
			return apierr.Fail(apierr.CodeConflict, "order payment is already in progress")
		}
	}
	if err := runProvision(ctx, o, op); err != nil {
		return err
	}
	message.SendAdmin(ctx, o.UserID, message.Compose(
		"Your order #", o.ID.Hex(), " created its server; please confirm it in the control panel"))
	return nil
}

func orderExpired(o *models.Order, now time.Time) bool {
	return !o.CreatedAt.IsZero() && !now.Before(o.CreatedAt.Add(PendingOrderLifetime))
}

// ExpirePending closes orders whose payment window has elapsed.
func (OrderService) ExpirePending(ctx context.Context) {
	if _, err := store.Order.CloseExpired(ctx, time.Now()); err != nil {
		glgf.Error("order: cannot close expired orders: ", err)
	}
}

func prepareProvision(ctx context.Context, o *models.Order, paymentMethod string, keyID bson.ObjectID, allocationID int, hostName string) (*models.ProvisionOperation, error) {
	u, err := store.User.ByID(ctx, o.UserID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	spec, err := store.Spec.ByID(ctx, o.SpecID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	cli := pterodactyl.ClientFromConf()
	pteUser, err := cli.GetUser(ctx, u.Name)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodePterodactylError, "cannot find the panel account", err)
	}
	// A product pinned to node 0 is placed on a randomly chosen node, which
	// spreads new servers across the fleet.
	nodeID := spec.Node
	if nodeID == 0 {
		nodes, err := cli.GetAllNodes(ctx)
		if err != nil {
			return nil, apierr.Wrap(apierr.CodePterodactylError, "cannot list panel nodes", err)
		}
		if len(nodes) == 0 {
			return nil, apierr.Fail(apierr.CodePterodactylError, "the panel has no nodes")
		}
		nodeID = nodes[rand.Intn(len(nodes))].Id
	}
	// The panel server is named "<username><order id>", which is the legacy
	// convention (sell_order_manager.go:123). The port has no numeric order id,
	// so the ObjectID hex stands in for it; the username prefix is what the
	// panel operator sees and what legacy used to group servers per customer.
	externalID := u.Name + o.ID.Hex()
	validDate := time.Now().Add(spec.ValidDuration)
	request, err := cli.PrepareCreateServerRequest(ctx, pterodactyl.Server{
		ExternalId:  externalID,
		Name:        externalID,
		Description: ExpiryLabel + validDate.Format(dateOnly),
		Limits: pterodactyl.ServerLimit{
			Memory: spec.Memory,
			Swap:   spec.Swap,
			Disk:   spec.Disk,
			IO:     spec.Io,
			CPU:    spec.Cpu,
			// The panel OOM killer stays enabled unconditionally; legacy
			// hardcodes it at product creation (sell_order_manager.go:133).
			OOMDisabled: true,
		},
		FeatureLimits: pterodactyl.FeatureLimit{Backups: spec.Backups},
		UserId:        pteUser.Uid,
		NodeId:        nodeID,
		Allocation:    allocationID,
		NestId:        spec.PanelLegacyNestID(),
		EggId:         spec.Egg,
		TagSlug:       spec.TagSlug,
		AllowedEggIDs: allowedEggs(spec),
		DockerImage:   spec.DockerImage,
	})
	if err != nil {
		return nil, apierr.Wrap(apierr.CodePterodactylError, "cannot prepare the server", err)
	}
	return &models.ProvisionOperation{ID: "order:" + o.ID.Hex() + ":" + bson.NewObjectID().Hex(), PaymentMethod: paymentMethod, KeyID: keyID, Amount: uint64(o.FinalPrice), AllocationID: allocationID, ExternalID: externalID, CustomerHost: hostName, PanelHost: cli.HostName(), TokenFingerprint: cli.IdentityFingerprint(), ExpiresAt: validDate, ValidDuration: spec.ValidDuration, CreatePayload: request, State: "claimed"}, nil
}

func runProvision(ctx context.Context, o *models.Order, op *models.ProvisionOperation) error {
	workCtx, cancel := context.WithTimeout(ctx, time.Minute)
	defer cancel()
	leaseID := bson.NewObjectID().Hex()
	now := time.Now()
	acquired, err := store.Order.AcquireProvisionLease(workCtx, o.ID, op.ID, leaseID, now, now.Add(2*time.Minute))
	if err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot claim order recovery", err)
	}
	if !acquired {
		return apierr.Fail(apierr.CodeConflict, "order payment is already in progress")
	}
	defer func() { _ = store.Order.ReleaseProvisionLease(context.Background(), o.ID, op.ID, leaseID) }()
	fresh, err := store.Order.ByID(workCtx, o.ID)
	if err != nil || fresh.Provision == nil || fresh.Provision.ID != op.ID {
		return apierr.Wrap(apierr.CodeInternal, "order operation disappeared", err)
	}
	if fresh.Paid || fresh.Provision.State == "completed" {
		return nil
	}
	op = fresh.Provision
	return runProvisionOwned(workCtx, o, op, leaseID)
}

func runProvisionOwned(ctx context.Context, o *models.Order, op *models.ProvisionOperation, leaseID string) error {
	current := pterodactyl.ClientFromConf()
	if current.HostName() != op.PanelHost || current.IdentityFingerprint() != op.TokenFingerprint {
		return apierr.Fail(apierr.CodePterodactylError, "the panel credentials for this pending order have changed")
	}
	if op.State == "claimed" || op.State == "ready" {
		if op.PaymentMethod == "key" {
			key, err := store.Key.Claim(ctx, op.KeyID, op.ID, o.UserID, o.SpecID, time.Now())
			if err != nil {
				if errors.Is(err, store.ErrNotFound) {
					if stateErr := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "payment_failed"); stateErr != nil {
						return apierr.Wrap(apierr.CodeInternal, "cannot release failed order payment", stateErr)
					}
					return apierr.Wrap(apierr.CodeInvalidKey, "activation code is not available", err)
				}
				return apierr.Wrap(apierr.CodeInternal, "cannot determine activation code claim state", err)
			}
			_ = key
		} else if op.PaymentMethod == "balance" {
			if op.Amount > math.MaxInt64 {
				return apierr.Fail(apierr.CodeValidationFailed, "order amount is invalid")
			}
			var err error
			if op.Amount > 0 {
				_, err = store.User.ApplyBalanceOnce(ctx, o.UserID, op.ID, -int64(op.Amount))
			}
			if errors.Is(err, store.ErrBalanceOperationCanceled) {
				if stateErr := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "payment_failed"); stateErr != nil {
					return apierr.Wrap(apierr.CodeInternal, "cannot finalize canceled order payment", stateErr)
				}
				return apierr.Fail(apierr.CodeInsufficientBalance, "your balance is not enough")
			}
			if errors.Is(err, store.ErrInsufficientBalance) {
				canceled, applied, cancelErr := store.User.CancelBalanceOperation(ctx, o.UserID, op.ID, op.Amount)
				if cancelErr != nil {
					return apierr.Wrap(apierr.CodeInternal, "cannot resolve order payment", cancelErr)
				}
				if applied {
					err = nil
				} else if canceled {
					if stateErr := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "payment_failed"); stateErr != nil {
						return apierr.Wrap(apierr.CodeInternal, "cannot record failed order payment", stateErr)
					}
					return apierr.Wrap(apierr.CodeInsufficientBalance, "your balance is not enough", err)
				} else {
					return apierr.Fail(apierr.CodeInternal, "cannot determine order payment state")
				}
			}
			if err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot charge the balance", err)
			}
		} else {
			return apierr.Fail(apierr.CodeInternal, "unknown payment method in pending order")
		}
		if op.State == "claimed" {
			if err := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "ready"); err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot update order operation", err)
			}
			op.State = "ready"
		}
	}
	if op.State == "claimed" || op.State == "ready" || op.State == "creating" {
		created, err := current.GetServerUncached(ctx, op.ExternalID)
		if err != nil && !pterodactyl.IsNotFound(err) {
			return apierr.Wrap(apierr.CodePterodactylError, "cannot verify the server on the panel", err)
		}
		if err == nil && created != nil {
			if err := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "server_created"); err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot record server creation", err)
			}
			op.State = "server_created"
		} else {
			if op.State == "creating" || op.State == "ready" {
				if err := rebaseProvisionExpiry(ctx, o, op, leaseID); err != nil {
					return err
				}
			}
			if op.State != "creating" {
				if err := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "creating"); err != nil {
					return apierr.Wrap(apierr.CodeInternal, "cannot record create attempt", err)
				}
				op.State = "creating"
			}
			createErr := current.CreateServerRequest(ctx, json.RawMessage(op.CreatePayload))
			if createErr != nil {
				created, lookupErr := current.GetServerUncached(ctx, op.ExternalID)
				if lookupErr != nil {
					if pterodactyl.IsNotFound(lookupErr) {
						return apierr.Wrap(apierr.CodePterodactylError, "server creation is pending retry", createErr)
					}
					return apierr.Wrap(apierr.CodePterodactylError, "server creation outcome is unknown", lookupErr)
				}
				if created == nil {
					return apierr.Fail(apierr.CodePterodactylError, "server creation outcome is unknown")
				}
			}
			if err := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "server_created"); err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot record server creation", err)
			}
			op.State = "server_created"
		}
	}
	entity := &models.WareEntity{UserID: o.UserID, SpecID: o.SpecID, OrderID: o.ID, ServerExternalID: op.ExternalID, UserExternalID: strings.TrimSuffix(op.ExternalID, o.ID.Hex()), HostName: op.CustomerHost, ValidDate: op.ExpiresAt}
	if err := store.Entity.EnsureForOrder(ctx, o.ID, entity); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot record the server", err)
	}
	if op.State != "entity_recorded" && op.State != "completed" {
		if err := store.Order.AdvanceProvision(ctx, o.ID, op.ID, leaseID, "entity_recorded"); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot record the server", err)
		}
	}
	if err := store.Order.CompleteProvision(ctx, o.ID, op.ID, leaseID, op.AllocationID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot confirm the order", err)
	}
	if op.PaymentMethod == "key" {
		if err := consumeProvisionKey(ctx, o, op); err != nil {
			glgf.Error("order: cannot finish redeeming key: ", err)
		}
	}
	return nil
}

func consumeProvisionKey(ctx context.Context, o *models.Order, op *models.ProvisionOperation) error {
	if err := store.Key.DeleteClaimed(ctx, op.KeyID, op.ID, o.UserID); err != nil {
		return err
	}
	return store.Order.MarkProvisionKeyConsumed(ctx, o.ID, op.ID)
}

func rebaseProvisionExpiry(ctx context.Context, o *models.Order, op *models.ProvisionOperation, leaseID string) error {
	if op.ValidDuration <= 0 {
		return apierr.Fail(apierr.CodeInternal, "pending order has no stored service duration")
	}
	var payload map[string]any
	if err := json.Unmarshal(op.CreatePayload, &payload); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot read persisted create request", err)
	}
	expires := time.Now().Add(op.ValidDuration)
	payload["description"] = ExpiryLabel + expires.Format(dateOnly)
	request, err := json.Marshal(payload)
	if err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot update persisted create request", err)
	}
	if err := store.Order.RebaseProvisionExpiry(ctx, o.ID, op.ID, leaseID, expires, request); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot persist renewed service expiry", err)
	}
	op.ExpiresAt = expires
	op.CreatePayload = request
	return nil
}
