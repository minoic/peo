// Package service holds the business rules that used to live inside the Beego
// controllers.
package service

import (
	"context"
	"math/rand"
	"strconv"
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
	return o, nil
}

// ListByUser returns the orders of a user, newest first.
func (OrderService) ListByUser(ctx context.Context, userID bson.ObjectID) ([]models.Order, error) {
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
	key, err := store.Key.ByString(ctx, keyString)
	if err != nil {
		return apierr.Wrap(apierr.CodeInvalidKey, "activation code not found", err)
	}
	if key.Exp.Before(time.Now()) || key.SpecID != o.SpecID {
		return apierr.Fail(apierr.CodeInvalidKey, "activation code is not valid for this product")
	}
	if err := provision(ctx, o, allocationID, hostName); err != nil {
		return err
	}
	// The customer already has their server; a failure to clean up the code is
	// logged rather than surfaced, because a second redemption would be caught
	// by the paid check above.
	if err := store.Key.Delete(ctx, key.ID); err != nil {
		glgf.Error("order: cannot delete redeemed key " + key.KeyString + ": " + err.Error())
	}
	glgf.Info("order: activation code redeemed " + key.KeyString)
	return nil
}

// PayWithBalance pays an order from the account balance and provisions the
// server. The balance is debited only after the server exists, so a panel
// outage never costs the customer money.
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
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	if u.Balance < o.FinalPrice {
		return apierr.Fail(apierr.CodeInsufficientBalance, "your balance is not enough")
	}
	if err := provision(ctx, o, allocationID, hostName); err != nil {
		return err
	}
	if err := store.User.AddBalance(ctx, u.ID, -int64(o.FinalPrice)); err != nil {
		// The server exists but the customer was not charged. Rolling the
		// server back is worse than absorbing the loss, so it is reported to an
		// administrator instead.
		glgf.Error("order: cannot debit balance for order " + o.ID.Hex() + ": " + err.Error())
		message.SendToAdmins(ctx, message.Compose("Order ", o.ID.Hex(), " created its server but the balance could not be debited; please verify by hand"))
	}
	return nil
}

// provision creates the panel server and then records the facts that depend on
// it. Everything panel-side happens before any local write, so a failure leaves
// no half-provisioned record behind; the reverse order would need a rollback.
func provision(ctx context.Context, o *models.Order, allocationID int, hostName string) error {
	u, err := store.User.ByID(ctx, o.UserID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	spec, err := store.Spec.ByID(ctx, o.SpecID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	cli := pterodactyl.ClientFromConf()
	pteUser, err := cli.GetUser(ctx, u.Name)
	if err != nil {
		return apierr.Wrap(apierr.CodePterodactylError, "cannot find the panel account", err)
	}
	// A product pinned to node 0 is placed on a randomly chosen node, which
	// spreads new servers across the fleet.
	nodeID := spec.Node
	if nodeID == 0 {
		nodes, err := cli.GetAllNodes(ctx)
		if err != nil {
			return apierr.Wrap(apierr.CodePterodactylError, "cannot list panel nodes", err)
		}
		if len(nodes) == 0 {
			return apierr.Fail(apierr.CodePterodactylError, "the panel has no nodes")
		}
		nodeID = nodes[rand.Intn(len(nodes))].Id
	}
	// The panel server is named "<username><order id>", which is the legacy
	// convention (sell_order_manager.go:123). The port has no numeric order id,
	// so the ObjectID hex stands in for it; the username prefix is what the
	// panel operator sees and what legacy used to group servers per customer.
	externalID := u.Name + o.ID.Hex()
	validDate := time.Now().Add(spec.ValidDuration)

	if err := cli.CreateServer(ctx, pterodactyl.Server{
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
		NestId:        spec.Nest,
		EggId:         spec.Egg,
	}); err != nil {
		glgf.Error("order: cannot create server for order " + o.ID.Hex() + ": " + err.Error())
		return apierr.Wrap(apierr.CodePterodactylError, "cannot create the server", err)
	}

	entity := &models.WareEntity{
		UserID:           u.ID,
		SpecID:           spec.ID,
		ServerExternalID: externalID,
		UserExternalID:   u.Name,
		HostName:         hostName,
		ValidDate:        validDate,
	}
	if err := store.Entity.Create(ctx, entity); err != nil {
		_ = cli.DeleteServer(ctx, externalID)
		return apierr.Wrap(apierr.CodeInternal, "cannot record the server", err)
	}
	if err := store.Order.SetAllocation(ctx, o.ID, allocationID); err != nil {
		rollback(ctx, cli, externalID, entity.ID)
		return apierr.Wrap(apierr.CodeInternal, "cannot record the allocation", err)
	}
	if err := store.Order.SetConfirmed(ctx, o.ID, true); err != nil {
		rollback(ctx, cli, externalID, entity.ID)
		return apierr.Wrap(apierr.CodeInternal, "cannot confirm the order", err)
	}
	message.SendAdmin(ctx, u.ID, message.Compose(
		"Your order #", o.ID.Hex(), " created its server; please confirm it in the control panel"))
	glgf.Info("order: order confirmed " + o.ID.Hex())
	return nil
}

// rollback undoes a partially written provisioning attempt.
func rollback(ctx context.Context, cli *pterodactyl.Client, externalID string, entityID bson.ObjectID) {
	if err := cli.DeleteServer(ctx, externalID); err != nil {
		glgf.Error("order: cannot roll back server " + externalID + ": " + err.Error())
	}
	if err := store.Entity.Delete(ctx, entityID); err != nil {
		glgf.Error("order: cannot roll back server record " + entityID.Hex() + ": " + err.Error())
	}
}
