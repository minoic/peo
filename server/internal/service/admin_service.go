package service

import (
	"archive/zip"
	"bytes"
	"context"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/buildinfo"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/cryptoo"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// Activation code targets. The legacy admin form encoded the action in the same
// numeric field as the product id, using sentinel values near the maximum uint64
// because MySQL ids are integers. Mongo ids are hex strings, so the client names
// the target explicitly instead of relying on numeric near-collisions.
const (
	// TargetAllSpecs mints codes for every product definition.
	TargetAllSpecs = "all"
	// TargetAllBalance mints balance codes for every denomination.
	TargetAllBalance = "balance:all"
	// targetSpecPrefix / targetBalancePrefix introduce the two parameterised
	// target forms: "spec:<hex>" and "balance:<amount>".
	targetSpecPrefix    = "spec:"
	targetBalancePrefix = "balance:"
)

// balanceDenominations are the recharge amounts the back office can mint codes
// for, in the order the legacy code created them.
var balanceDenominations = []uint{30, 50, 100}

// BalanceTarget builds the target string for one denomination.
func BalanceTarget(balance uint) string {
	return targetBalancePrefix + strconv.FormatUint(uint64(balance), 10)
}

// SpecTarget builds the target string for one product definition.
func SpecTarget(specID bson.ObjectID) string { return targetSpecPrefix + specID.Hex() }

// AdminService owns every back office operation: dashboard figures, the user
// and order listings, product CRUD, activation code minting, ticket closing,
// album moderation, deletion confirmation and the runtime settings form.
type AdminService struct{}

// Admin is the default AdminService.
var Admin = AdminService{}

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------

// Dashboard is the landing payload of the admin console.
type Dashboard struct {
	SpecAmount     int64               `json:"specAmount"`
	EntityAmount   int64               `json:"entityAmount"`
	UserAmount     int64               `json:"userAmount"`
	KeyAmount      int64               `json:"keyAmount"`
	OrderAmount    int64               `json:"orderAmount"`
	WorkOrderCount int64               `json:"workOrderCount"`
	GalleryCount   int64               `json:"galleryCount"`
	GalleryItems   []GalleryItem       `json:"galleryItems"`
	WorkOrders     []WorkOrderItem     `json:"workOrders"`
	DeleteConfirms []DeleteConfirmItem `json:"deleteConfirms"`
}

// DeleteConfirmItem is one server waiting for an administrator to confirm its
// removal. ConsoleURL points at the Pterodactyl panel page of the server so the
// operator can inspect it before deciding.
type DeleteConfirmItem struct {
	EntityID   string `json:"entityId"`
	ConfirmID  string `json:"confirmId"`
	ServerName string `json:"serverName"`
	ConsoleURL string `json:"consoleUrl"`
	Identifier string `json:"identifier"`
	Owner      string `json:"owner"`
	Expire     string `json:"expire"`
	HostName   string `json:"hostName"`
}

// WorkOrderItem is a ticket as shown to staff.
type WorkOrderItem struct {
	ID         string `json:"id"`
	UserID     string `json:"userId"`
	UserName   string `json:"userName"`
	OrderTitle string `json:"orderTitle"`
	OrderText  string `json:"orderText"`
	CreatedAt  string `json:"createdAt"`
	Closed     bool   `json:"closed"`
}

// Dashboard assembles the counters and the three moderation lists. Reading the
// dashboard also prunes pending deletions whose server has already disappeared
// or whose owner has withdrawn the request, so the list stays trustworthy
// without a dedicated cron job.
func (AdminService) Dashboard(ctx context.Context) (*Dashboard, error) {
	cli := pterodactyl.ClientFromConf()

	d := &Dashboard{}
	var err error
	if d.SpecAmount, err = store.Spec.Count(ctx); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the products", err)
	}
	if d.EntityAmount, err = store.Entity.Count(ctx); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the servers", err)
	}
	if d.UserAmount, err = store.User.Count(ctx); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the users", err)
	}
	wareKeys, err := store.Key.Count(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the activation codes", err)
	}
	rechargeKeys, err := store.RKey.Count(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the recharge codes", err)
	}
	d.KeyAmount = wareKeys + rechargeKeys
	if d.OrderAmount, err = store.Order.CountConfirmed(ctx); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the orders", err)
	}
	if d.WorkOrderCount, err = store.WorkOrder.CountOpen(ctx); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count the work orders", err)
	}

	orders, err := Admin.OpenWorkOrders(ctx)
	if err != nil {
		return nil, err
	}
	d.WorkOrders = orders

	items, err := store.Gallery.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the album", err)
	}
	d.GalleryItems = Gallery.decorate(ctx, items)
	d.GalleryCount = int64(len(d.GalleryItems))

	confirms, err := Admin.deleteConfirms(ctx, cli)
	if err != nil {
		return nil, err
	}
	d.DeleteConfirms = confirms
	return d, nil
}

// OpenWorkOrders lists the unresolved tickets for the dashboard.
func (AdminService) OpenWorkOrders(ctx context.Context) ([]WorkOrderItem, error) {
	orders, err := store.WorkOrder.Open(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the work orders", err)
	}
	return WorkOrderItems(orders), nil
}

// WorkOrderItems renders stored tickets into the wire shape shared by the
// customer list and the admin console, so both endpoints agree on the fields.
func WorkOrderItems(orders []models.WorkOrder) []WorkOrderItem {
	out := make([]WorkOrderItem, 0, len(orders))
	for i := range orders {
		o := &orders[i]
		out = append(out, WorkOrderItem{
			ID:         o.ID.Hex(),
			UserID:     o.UserID.Hex(),
			UserName:   o.UserName,
			OrderTitle: o.OrderTitle,
			OrderText:  o.OrderText,
			CreatedAt:  o.CreatedAt.Format("2006-01-02 15:04"),
			Closed:     o.Closed,
		})
	}
	return out
}

// deleteConfirms builds the pending deletion list. A row whose server is gone,
// or whose owner has retracted the request, is removed from the database and
// skipped instead of being shown as an actionable entry.
func (AdminService) deleteConfirms(ctx context.Context, cli *pterodactyl.Client) ([]DeleteConfirmItem, error) {
	confirms, err := store.DeleteConfirm.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the pending deletions", err)
	}
	out := make([]DeleteConfirmItem, 0, len(confirms))
	for i := range confirms {
		c := &confirms[i]
		entity, err := store.Entity.ByID(ctx, c.WareID)
		if err != nil || entity.DeleteStatus != 1 {
			// The server is gone or its owner withdrew the request: the
			// confirmation row is stale, so it is dropped.
			if err := store.DeleteConfirm.DeleteByWare(ctx, c.WareID); err != nil {
				glgf.Error("admin: cannot drop a stale delete confirmation: ", err)
			}
			continue
		}
		server, err := cli.GetServer(ctx, entity.ServerExternalID)
		if err != nil {
			glgf.Error("admin: cannot read server ", entity.ServerExternalID, ": ", err)
			continue
		}
		identifier := server.Identifier
		out = append(out, DeleteConfirmItem{
			EntityID:   entity.ID.Hex(),
			ConfirmID:  c.ID.Hex(),
			ServerName: entity.ServerExternalID,
			ConsoleURL: cli.HostName() + "/server/" + identifier,
			Identifier: identifier,
			Owner:      entity.UserExternalID,
			Expire:     entity.ValidDate.Format("2006-01-02"),
			HostName:   entity.HostName,
		})
	}
	return out, nil
}

// DeleteConfirms lists the pending deletions on their own.
func (AdminService) DeleteConfirms(ctx context.Context) ([]DeleteConfirmItem, error) {
	return Admin.deleteConfirms(ctx, pterodactyl.ClientFromConf())
}

// ConfirmDelete removes the server from the panel and from the database. The
// pterodactyl package already cleans up both the entity and the confirmation
// row, so the caller must not delete anything afterwards.
func (AdminService) ConfirmDelete(ctx context.Context, entityID bson.ObjectID) error {
	if err := pterodactyl.ConfirmDelete(ctx, entityID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot delete the server", err)
	}
	Admin.InvalidateServer(ctx, entityID)
	return nil
}

// RejectDelete cancels a pending deletion and lifts the suspension.
func (AdminService) RejectDelete(ctx context.Context, entityID bson.ObjectID) error {
	if err := pterodactyl.RejectDelete(ctx, entityID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot cancel the deletion", err)
	}
	Admin.InvalidateServer(ctx, entityID)
	return nil
}

// InvalidateServer drops the cached panel view of a server after its state has
// been changed through the back office.
func (AdminService) InvalidateServer(ctx context.Context, entityID bson.ObjectID) {
	entity, err := store.Entity.ByID(ctx, entityID)
	if err != nil {
		return
	}
	pterodactyl.InvalidateServer(entity.ServerExternalID)
}

// ---------------------------------------------------------------------------
// Users and orders
// ---------------------------------------------------------------------------

// AdminUser is one row of the back office user table. It is a projection: the
// legacy template received the raw model and therefore shipped the password
// hash to the browser, which this DTO makes impossible.
type AdminUser struct {
	ID             string `json:"id"`
	Name           string `json:"name"`
	Email          string `json:"email"`
	Balance        uint   `json:"balance"`
	IsAdmin        bool   `json:"isAdmin"`
	EmailConfirmed bool   `json:"emailConfirmed"`
	PteUserCreated bool   `json:"pteUserCreated"`
	TotalUpTime    int64  `json:"totalUpTime"`
	CreatedAt      string `json:"createdAt"`
}

// Users lists every account, newest first.
func (AdminService) Users(ctx context.Context) ([]AdminUser, error) {
	users, err := store.User.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the users", err)
	}
	out := make([]AdminUser, 0, len(users))
	for i := range users {
		u := &users[i]
		out = append(out, AdminUser{
			ID:             u.ID.Hex(),
			Name:           u.Name,
			Email:          u.Email,
			Balance:        u.Balance,
			IsAdmin:        u.IsAdmin,
			EmailConfirmed: u.EmailConfirmed,
			PteUserCreated: u.PteUserCreated,
			TotalUpTime:    int64(u.TotalUpTime),
			CreatedAt:      u.CreatedAt.Format("2006-01-02 15:04"),
		})
	}
	return out, nil
}

// AdminOrder is one row of the back office order table, with the customer name
// and the product name joined in so the client needs a single request.
type AdminOrder struct {
	ID         string `json:"id"`
	UserName   string `json:"userName"`
	SpecName   string `json:"specName"`
	SpecDays   int    `json:"specDays"`
	FinalPrice uint   `json:"finalPrice"`
	CreatedAt  string `json:"createdAt"`
}

// Orders lists the fulfilled orders, newest first.
func (AdminService) Orders(ctx context.Context) ([]AdminOrder, error) {
	orders, err := store.Order.Confirmed(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the orders", err)
	}
	names := make(map[bson.ObjectID]string)
	specs := make(map[bson.ObjectID]*models.WareSpec)
	out := make([]AdminOrder, 0, len(orders))
	for i := range orders {
		o := &orders[i]
		userName, ok := names[o.UserID]
		if !ok {
			if u, err := store.User.ByID(ctx, o.UserID); err == nil {
				userName = u.Name
			}
			names[o.UserID] = userName
		}
		spec, ok := specs[o.SpecID]
		if !ok {
			if s, err := store.Spec.ByID(ctx, o.SpecID); err == nil {
				spec = s
			}
			specs[o.SpecID] = spec
		}
		row := AdminOrder{
			ID:         o.ID.Hex(),
			UserName:   userName,
			FinalPrice: o.FinalPrice,
			CreatedAt:  o.CreatedAt.Format("2006-01-02 15:04"),
		}
		if spec != nil {
			row.SpecName = spec.WareName
			row.SpecDays = days(spec.ValidDuration)
		}
		out = append(out, row)
	}
	return out, nil
}

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

// ProductInput is the payload of the back office product editor. It mirrors the
// legacy new-ware form field for field.
//
// There is deliberately no `startup` member: the Pterodactyl create-server call
// always derives the startup command from the egg, so the legacy form's startup
// box never reached the database and is not resurrected here.
type ProductInput struct {
	WareName        string `json:"wareName"`
	WareDescription string `json:"wareDescription"`
	Cpu             int    `json:"cpu"`
	Disk            int    `json:"disk"`
	Memory          int    `json:"memory"`
	Swap            int    `json:"swap"`
	Io              int    `json:"io"`
	Backups         int    `json:"backups"`
	NodeID          int    `json:"nodeId"`
	NestID          int    `json:"nestId"`
	EggID           int    `json:"eggId"`
	Image           string `json:"image"`
	DeleteTime      int    `json:"deleteTime"`
	Price           uint   `json:"price"`
	Discount0       int    `json:"discount0"`
	Discount1       int    `json:"discount1"`
	Discount2       int    `json:"discount2"`
	// Discount is used by the single-cycle update path only; creation derives
	// the per-cycle discounts from Discount0/1/2.
	Discount int `json:"discount"`
}

// FormField describes one input of a generated form. The client renders it,
// which is why the server ships a schema instead of HTML.
type FormField struct {
	Name        string      `json:"name"`
	Label       string      `json:"label"`
	Description string      `json:"description"`
	Type        string      `json:"type"`
	Required    bool        `json:"required"`
	Default     interface{} `json:"default"`
}

// billingCycles pairs the three durations a new product is created for with the
// form field that carries its discount. A cycle whose discount is 100 is
// disabled and produces no document at all.
var billingCycles = []struct {
	Duration time.Duration
	Field    string
}{
	{durationMonthly, "discount0"},
	{durationQuarterly, "discount1"},
	{durationYearly, "discount2"},
}

// ProductForm returns the descriptor of the product editor.
func (AdminService) ProductForm() []FormField {
	return []FormField{
		{Name: "ware_name", Label: "Product name", Description: "Shown in the product list and on the order page.", Type: "text", Required: true},
		{Name: "ware_description", Label: "Product description", Description: "Extra text shown on the product page (optional).", Type: "text"},
		{Name: "cpu", Label: "CPU limit", Description: "CPU percentage; 100 means one full core.", Type: "number", Required: true, Default: 0},
		{Name: "disk", Label: "Disk limit", Description: "Disk quota in MB.", Type: "number", Required: true, Default: 0},
		{Name: "memory", Label: "Memory limit", Description: "Memory quota in MB.", Type: "number", Required: true, Default: 0},
		{Name: "swap", Label: "Swap limit", Description: "Swap quota in MB; -1 disables the limit.", Type: "number", Required: true, Default: 0},
		{Name: "io", Label: "Block IO Weight", Description: "Disk IO weight, between 100 and 1000.", Type: "number", Required: true, Default: 500},
		{Name: "backups", Label: "Backup limit", Description: "Number of backups the customer may create, between 0 and 1000.", Type: "number", Required: true, Default: 0},
		{Name: "node_id", Label: "Node ID", Description: "Panel node the server is created on.", Type: "number", Required: true, Default: 0},
		{Name: "nest_id", Label: "Nest ID", Description: "Nest the server uses.", Type: "number", Required: true},
		{Name: "egg_id", Label: "Egg ID", Description: "Egg the server uses; it must belong to the nest above.", Type: "number", Required: true},
		{Name: "image", Label: "Docker image", Description: "Custom Docker image (optional); leave empty for the egg default.", Type: "text"},
		{Name: "delete_time", Label: "Delete delay (days)", Description: "Grace period before an expired server may be deleted.", Type: "number", Required: true, Default: 7},
		{Name: "price", Label: "Price (per 30 days, CNY)", Description: "Undiscounted monthly price in CNY.", Type: "number", Required: true},
		{Name: "discount0", Label: "Monthly discount", Description: "Integer from 0 to 100; 100 disables this billing cycle.", Type: "number", Required: true, Default: 0},
		{Name: "discount1", Label: "Quarterly discount", Description: "Integer from 0 to 100; 100 disables this billing cycle.", Type: "number", Required: true, Default: 0},
		{Name: "discount2", Label: "Yearly discount", Description: "Integer from 0 to 100; 100 disables this billing cycle.", Type: "number", Required: true, Default: 0},
	}
}

// AdminProduct is one row of the back office product table.
type AdminProduct struct {
	SpecID            string `json:"specId"`
	WareName          string `json:"wareName"`
	WareDescription   string `json:"wareDescription"`
	PricePerMonth     uint   `json:"pricePerMonth"`
	Discount          int    `json:"discount"`
	ValidDays         int    `json:"validDays"`
	DeleteDays        int    `json:"deleteDays"`
	Memory            int    `json:"memory"`
	Cpu               int    `json:"cpu"`
	Disk              int    `json:"disk"`
	Swap              int    `json:"swap"`
	Io                int    `json:"io"`
	Backups           int    `json:"backups"`
	Node              int    `json:"node"`
	Nest              int    `json:"nest"`
	Egg               int    `json:"egg"`
	DockerImage       string `json:"dockerImage"`
	OomDisabled       bool   `json:"oomDisabled"`
	StartOnCompletion bool   `json:"startOnCompletion"`
}

// ProductList returns every product definition, oldest first.
func (AdminService) ProductList(ctx context.Context) ([]AdminProduct, error) {
	specs, err := store.Spec.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the products", err)
	}
	out := make([]AdminProduct, 0, len(specs))
	for i := range specs {
		s := &specs[i]
		out = append(out, AdminProduct{
			SpecID:            s.ID.Hex(),
			WareName:          s.WareName,
			WareDescription:   s.WareDescription,
			PricePerMonth:     s.PricePerMonth,
			Discount:          s.Discount,
			ValidDays:         days(s.ValidDuration),
			DeleteDays:        days(s.DeleteDuration),
			Memory:            s.Memory,
			Cpu:               s.Cpu,
			Disk:              s.Disk,
			Swap:              s.Swap,
			Io:                s.Io,
			Backups:           s.Backups,
			Node:              s.Node,
			Nest:              s.Nest,
			Egg:               s.Egg,
			DockerImage:       s.DockerImage,
			OomDisabled:       s.OomDisabled,
			StartOnCompletion: s.StartOnCompletion,
		})
	}
	return out, nil
}

// CreateProduct validates the form and writes one document per enabled billing
// cycle, mirroring the legacy behaviour where a single submission produced up
// to three product rows sharing a name and differing only in duration and
// discount.
func (AdminService) CreateProduct(ctx context.Context, in ProductInput) ([]string, error) {
	if err := Admin.validateProduct(ctx, &in); err != nil {
		return nil, err
	}
	discounts := []int{in.Discount0, in.Discount1, in.Discount2}
	ids := make([]string, 0, len(billingCycles))
	for i, cycle := range billingCycles {
		if discounts[i] == 100 {
			continue
		}
		spec := Admin.specFromInput(in)
		spec.ValidDuration = cycle.Duration
		spec.Discount = discounts[i]
		if err := store.Spec.Create(ctx, spec); err != nil {
			return ids, apierr.Wrap(apierr.CodeInternal, "cannot save the product", err)
		}
		ids = append(ids, spec.ID.Hex())
	}
	if len(ids) == 0 {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "at least one billing cycle must be enabled")
	}
	Admin.refreshProducts(ctx, in.NestID)
	return ids, nil
}

// UpdateProduct rewrites one product definition. It intentionally does not
// re-run the multi-cycle creation logic: a row is one billing cycle, and the
// operator edits that cycle.
func (AdminService) UpdateProduct(ctx context.Context, specID bson.ObjectID, in ProductInput) error {
	if err := Admin.validateProduct(ctx, &in); err != nil {
		return err
	}
	if in.Discount < 0 || in.Discount > 100 {
		return apierr.Fail(apierr.CodeValidationFailed, "discount must be between 0 and 100")
	}
	if _, err := store.Spec.ByID(ctx, specID); err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	spec := Admin.specFromInput(in)
	spec.Discount = in.Discount
	if err := store.Spec.Update(ctx, specID, spec); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot save the product", err)
	}
	Admin.refreshProducts(ctx, in.NestID)
	return nil
}

// DeleteProduct removes a product definition and rebuilds the storefront.
func (AdminService) DeleteProduct(ctx context.Context, specID bson.ObjectID) error {
	spec, err := store.Spec.ByID(ctx, specID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	if err := store.Spec.Delete(ctx, specID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot delete the product", err)
	}
	Admin.refreshProducts(ctx, spec.Nest)
	return nil
}

// specFromInput builds a model from an already validated form payload.
func (AdminService) specFromInput(in ProductInput) *models.WareSpec {
	return &models.WareSpec{
		PricePerMonth:     in.Price,
		WareName:          strings.TrimSpace(in.WareName),
		WareDescription:   strings.TrimSpace(in.WareDescription),
		Node:              in.NodeID,
		Memory:            in.Memory,
		Cpu:               in.Cpu,
		Swap:              in.Swap,
		Disk:              in.Disk,
		Io:                in.Io,
		Backups:           in.Backups,
		Nest:              in.NestID,
		Egg:               in.EggID,
		StartOnCompletion: true,
		OomDisabled:       true,
		DockerImage:       strings.TrimSpace(in.Image),
		DeleteDuration:    time.Duration(in.DeleteTime*24) * time.Hour,
	}
}

// validateProduct reproduces the legacy new-ware form validation, including the
// panel lookups that guarantee the node and the egg really exist. The wording is
// kept close to the original so an operator recognises the failures.
func (AdminService) validateProduct(ctx context.Context, in *ProductInput) error {
	if strings.TrimSpace(in.WareName) == "" {
		return apierr.Fail(apierr.CodeValidationFailed, "a product name is required")
	}
	if in.Cpu < 0 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid CPU value")
	}
	if in.Disk < 0 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid disk value")
	}
	if in.Memory < 0 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid memory value")
	}
	if in.Io < 100 || in.Io > 1000 {
		return apierr.Fail(apierr.CodeValidationFailed, "Block IO Weight is outside the recommended range")
	}
	if in.Backups < 0 || in.Backups > 1000 {
		return apierr.Fail(apierr.CodeValidationFailed, "the backup limit is outside the recommended range")
	}
	if in.Swap < -1 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid swap value")
	}
	for _, d := range []int{in.Discount0, in.Discount1, in.Discount2} {
		if d < 0 || d > 100 {
			return apierr.Fail(apierr.CodeValidationFailed, "discount must be between 0 and 100")
		}
	}
	if in.DeleteTime < 0 {
		return apierr.Fail(apierr.CodeValidationFailed, "the delete delay cannot be negative")
	}

	cli := pterodactyl.ClientFromConf()
	if _, err := cli.GetNode(ctx, in.NodeID); err != nil {
		return apierr.Wrap(apierr.CodeValidationFailed, "the node id is negative or the node does not exist", err)
	}
	if _, err := cli.GetEgg(ctx, in.NestID, in.EggID); err != nil {
		return apierr.Wrap(apierr.CodeValidationFailed, "the egg does not exist in the panel", err)
	}
	return nil
}

// refreshProducts rebuilds the storefront cache and drops the cached egg list of
// the affected nest after a product change.
func (AdminService) refreshProducts(ctx context.Context, nestID int) {
	pterodactyl.InvalidateEggs(nestID)
	Products.InvalidateEggs(nestID)
	Products.Refresh(ctx)
}

// ---------------------------------------------------------------------------
// Activation codes
// ---------------------------------------------------------------------------

// GenerateKeys mints activation codes. The target selects one product, one
// balance denomination, every product or every balance denomination.
//
// The amount is bounded exactly like the legacy form bounded it (strictly
// between 0 and 100), and the validity window is given in days.
func (AdminService) GenerateKeys(ctx context.Context, target string, amount, validityDays int) error {
	if amount <= 0 || amount >= 100 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid code amount")
	}
	if validityDays <= 0 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid validity period")
	}
	switch {
	case target == TargetAllBalance:
		for _, balance := range balanceDenominations {
			if err := cryptoo.GenerateRechargeKeys(ctx, balance, amount, validityDays); err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot create the recharge codes", err)
			}
		}
		return nil
	case target == TargetAllSpecs:
		specs, err := store.Spec.All(ctx)
		if err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot read the products", err)
		}
		for i := range specs {
			if err := cryptoo.GenerateWareKeys(ctx, specs[i].ID, amount, validityDays); err != nil {
				return apierr.Wrap(apierr.CodeInternal, "cannot create the activation codes", err)
			}
		}
		return nil
	case strings.HasPrefix(target, targetBalancePrefix):
		raw := strings.TrimPrefix(target, targetBalancePrefix)
		if raw == "all" {
			for _, balance := range balanceDenominations {
				if err := cryptoo.GenerateRechargeKeys(ctx, balance, amount, validityDays); err != nil {
					return apierr.Wrap(apierr.CodeInternal, "cannot create the recharge codes", err)
				}
			}
			return nil
		}
		n, err := strconv.ParseUint(raw, 10, 32)
		if err != nil || n == 0 {
			return apierr.Fail(apierr.CodeValidationFailed, "invalid top-up amount")
		}
		if err := cryptoo.GenerateRechargeKeys(ctx, uint(n), amount, validityDays); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot create the recharge codes", err)
		}
		return nil
	case strings.HasPrefix(target, targetSpecPrefix):
		specID, err := models.ObjectIDFromHex(strings.TrimPrefix(target, targetSpecPrefix))
		if err != nil {
			return apierr.Fail(apierr.CodeValidationFailed, "product not found")
		}
		if _, err := store.Spec.ByID(ctx, specID); err != nil {
			return apierr.Wrap(apierr.CodeNotFound, "product not found", err)
		}
		if err := cryptoo.GenerateWareKeys(ctx, specID, amount, validityDays); err != nil {
			return apierr.Wrap(apierr.CodeInternal, "cannot create the activation codes", err)
		}
		return nil
	default:
		return apierr.Fail(apierr.CodeValidationFailed, "unknown activation code target")
	}
}

// KeyTargets lists everything the key generator can be pointed at, so the client
// does not have to hard-code the product ids.
func (AdminService) KeyTargets(ctx context.Context) ([]KeyTarget, error) {
	specs, err := store.Spec.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the products", err)
	}
	out := make([]KeyTarget, 0, len(specs)+len(balanceDenominations)+2)
	for i := range specs {
		out = append(out, KeyTarget{
			Target:      SpecTarget(specs[i].ID),
			Name:        specs[i].WareName,
			Description: "Memory:" + strconv.Itoa(specs[i].Memory),
			Validity:    days(specs[i].ValidDuration),
		})
	}
	out = append(out, KeyTarget{
		Target:      TargetAllSpecs,
		Name:        "All products",
		Description: "Covers every product",
		Validity:    -1,
	})
	for _, balance := range balanceDenominations {
		out = append(out, KeyTarget{
			Target:      BalanceTarget(balance),
			Name:        "Balance",
			Description: strconv.FormatUint(uint64(balance), 10) + " CNY",
			Validity:    0,
		})
	}
	out = append(out, KeyTarget{
		Target:      TargetAllBalance,
		Name:        "All balances",
		Description: "Covers every balance denomination",
		Validity:    0,
	})
	return out, nil
}

// KeyTarget is one entry of the key generator's target picker.
type KeyTarget struct {
	Target      string `json:"target"`
	Name        string `json:"name"`
	Description string `json:"description"`
	// Validity is the product's lifetime in days. Zero means the target is a
	// balance code and carries no lifetime, -1 means the target stands for every
	// product at once and the lifetime varies.
	Validity int `json:"validity"`
}

// ExportKeys renders every activation code into a zip archive. The legacy code
// wrote the files into a shared temporary directory from a set of goroutines and
// reported failures through a flag they all raced on; building the archive in
// memory removes both the race and the temporary files.
func (AdminService) ExportKeys(ctx context.Context) ([]byte, error) {
	buf := &bytes.Buffer{}
	zw := zip.NewWriter(buf)

	specs, err := store.Spec.All(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the products", err)
	}
	for i := range specs {
		keys, err := store.Key.BySpec(ctx, specs[i].ID)
		if err != nil {
			return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the activation codes", err)
		}
		if len(keys) == 0 {
			continue
		}
		name := fmt.Sprintf("key_%s_%dd.txt", sanitizeFileName(specs[i].WareName), days(specs[i].ValidDuration))
		if err := writeZipEntry(zw, name, keyLines(keys)); err != nil {
			return nil, apierr.Wrap(apierr.CodeInternal, "cannot build the archive", err)
		}
	}
	for _, balance := range balanceDenominations {
		keys, err := store.RKey.ByBalance(ctx, balance)
		if err != nil {
			return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the recharge codes", err)
		}
		if len(keys) == 0 {
			continue
		}
		lines := make([]string, 0, len(keys))
		for i := range keys {
			lines = append(lines, keys[i].KeyString)
		}
		if err := writeZipEntry(zw, fmt.Sprintf("recharge_key_%d.txt", balance), lines); err != nil {
			return nil, apierr.Wrap(apierr.CodeInternal, "cannot build the archive", err)
		}
	}
	if err := zw.Close(); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot build the archive", err)
	}
	return buf.Bytes(), nil
}

func keyLines(keys []models.WareKey) []string {
	lines := make([]string, 0, len(keys))
	for i := range keys {
		lines = append(lines, keys[i].KeyString)
	}
	return lines
}

func writeZipEntry(zw *zip.Writer, name string, lines []string) error {
	w, err := zw.Create(name)
	if err != nil {
		return err
	}
	_, err = w.Write([]byte(strings.Join(lines, "\n") + "\n"))
	return err
}

// sanitizeFileName replaces the characters that are illegal in a file name so a
// product name can be used as the archive entry name.
func sanitizeFileName(name string) string {
	name = strings.TrimSpace(name)
	if name == "" {
		return "product"
	}
	replacer := strings.NewReplacer("\\", "_", "/", "_", ":", "_", "*", "_",
		"?", "_", "\"", "_", "<", "_", ">", "_", "|", "_", " ", "_")
	return replacer.Replace(name)
}

// ---------------------------------------------------------------------------
// Tickets and album moderation
// ---------------------------------------------------------------------------

// CloseWorkOrder resolves a ticket, quoting the operator's reply to the
// customer. An already closed ticket is left alone.
func (AdminService) CloseWorkOrder(ctx context.Context, orderID bson.ObjectID, closeInfo string) error {
	return WorkOrders.CloseWithInfo(ctx, orderID, closeInfo)
}

// PassGalleryItem publishes a pending album submission.
func (AdminService) PassGalleryItem(ctx context.Context, itemID bson.ObjectID) error {
	if _, err := store.Gallery.ByID(ctx, itemID); err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "album item not found", err)
	}
	if err := store.Gallery.SetApproved(ctx, itemID, true); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot publish the album item", err)
	}
	return nil
}

// DeleteGalleryItem removes an album submission regardless of its author.
func (AdminService) DeleteGalleryItem(ctx context.Context, itemID bson.ObjectID) error {
	if _, err := store.Gallery.ByID(ctx, itemID); err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "album item not found", err)
	}
	if err := store.Gallery.Delete(ctx, itemID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot delete the album item", err)
	}
	return nil
}

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------

// Setting field types understood by the generated form.
const (
	SettingTypeText   = "text"
	SettingTypeNumber = "number"
	SettingTypeBool   = "bool"
)

// SettingField is one editable setting: its key, its label and the input the
// client should render. The schema lives on the server so the form and the
// persistence layer cannot drift apart.
type SettingField struct {
	Key         string `json:"key"`
	Label       string `json:"label"`
	Description string `json:"description"`
	Type        string `json:"type"`
	Value       string `json:"value"`
}

// settingsSchema is the ordered description of every editable setting. The
// legacy list mapped MYSQLHost/MYSQLDatabaseName onto the Mongo connection;
// the two MySQL credentials have no equivalent and are gone.
var settingsSchema = []SettingField{
	{Key: "WebHostName", Label: "Site address", Description: "Public address of the site. It must share a parent domain with the Pterodactyl panel and use HTTPS for single sign-on.", Type: SettingTypeText},
	{Key: "WebApplicationName", Label: "Site name", Description: "Shown in the page title and in outgoing mail.", Type: SettingTypeText},
	{Key: "WebDescription", Label: "Site description", Description: "Short one-line description of the site.", Type: SettingTypeText},
	{Key: "WebAdminAddress", Label: "Administrator contact", Description: "Contact address shown in the page footer.", Type: SettingTypeText},
	{Key: "PterodactylHostname", Label: "Panel address", Description: "Base address of the Pterodactyl panel. It must not end with a slash.", Type: SettingTypeText},
	{Key: "PterodactylToken", Label: "Panel token", Description: "Pterodactyl application API key.", Type: SettingTypeText},
	{Key: "DatabaseSalt", Label: "Database SALT", Description: "Password salt. Changing it logs every user out.", Type: SettingTypeText},
	{Key: "MongoURI", Label: "MongoDB address", Description: "Connection string, for example mongodb://IP:port.", Type: SettingTypeText},
	{Key: "MongoDatabaseName", Label: "MongoDB database name", Description: "Database that holds the business collections.", Type: SettingTypeText},
	{Key: "RedisHost", Label: "Redis address", Description: "Redis address in the form IP:port.", Type: SettingTypeText},
	{Key: "RedisPassword", Label: "Redis password", Description: "Leave empty when the server has no password.", Type: SettingTypeText},
	{Key: "RedisDB", Label: "Redis database", Description: "Index of the Redis database to use.", Type: SettingTypeText},
	{Key: "SMTPEnabled", Label: "Enable email", Description: "When disabled the site never sends any mail.", Type: SettingTypeBool},
	{Key: "SMTPHost", Label: "SMTP address", Description: "SMTP server hostname.", Type: SettingTypeText},
	{Key: "SMTPPort", Label: "SMTP port", Description: "SMTP server port.", Type: SettingTypeNumber},
	{Key: "SMTPSendFrom", Label: "Mail sender", Description: "For example ADMIN <admin@example.com>.", Type: SettingTypeText},
	{Key: "SMTPUsername", Label: "SMTP username", Description: "Login name for the SMTP server.", Type: SettingTypeText},
	{Key: "SMTPUserPassword", Label: "SMTP password", Description: "Login password for the SMTP server.", Type: SettingTypeText},
	{Key: "SMTPEncryption", Label: "SMTP encryption", Description: "Either TLS or SSL.", Type: SettingTypeText},
	{Key: "DeleteEmailConfirm", Label: "Deletion reminder", Description: "Send a reminder email when a server expires.", Type: SettingTypeBool},
	{Key: "RechargeMode", Label: "Top-up enabled", Description: "When enabled users may top up their balance on the site.", Type: SettingTypeBool},
	{Key: "TotalDiscount", Label: "Global discount", Description: "When disabled every discount is ignored.", Type: SettingTypeBool},
	{Key: "AliPayEnabled", Label: "Alipay enabled", Description: "Enable Alipay face-to-face top-up.", Type: SettingTypeBool},
	{Key: "AliPayPublicKey", Label: "Alipay public key", Description: "Public key issued by the Alipay open platform.", Type: SettingTypeText},
	{Key: "AliPayPrivateKey", Label: "Alipay private key", Description: "Application private key.", Type: SettingTypeText},
	{Key: "AliPayAppID", Label: "Alipay AppID", Description: "Application AppID.", Type: SettingTypeText},
	{Key: "AlbumEnabled", Label: "Gallery enabled", Description: "Enable the user gallery feature.", Type: SettingTypeBool},
	{Key: "SocialLink", Label: "Community link", Description: "Target address of the community link in the navigation bar.", Type: SettingTypeText},
	{Key: "SocialLinkTitle", Label: "Community link title", Description: "Text shown for the community link.", Type: SettingTypeText},
}

// Settings returns the schema with the current value of every key filled in.
// The TOML file is the single source of truth; there is no database override.
func (AdminService) Settings(ctx context.Context) ([]SettingField, error) {
	out := make([]SettingField, 0, len(settingsSchema))
	for _, f := range settingsSchema {
		f.Value = config.String(f.Key)
		out = append(out, f)
	}
	return out, nil
}

// SaveSettings validates every submitted value against the schema, applies it,
// writes the configuration file and reconnects the datastores so the change is
// live immediately. Unknown keys are ignored so an old client cannot introduce
// arbitrary entries.
func (AdminService) SaveSettings(ctx context.Context, values map[string]string) error {
	known := make(map[string]string, len(settingsSchema))
	for _, f := range settingsSchema {
		known[f.Key] = f.Type
	}
	for key, raw := range values {
		typ, ok := known[key]
		if !ok {
			continue
		}
		switch typ {
		case SettingTypeBool:
			b, err := strconv.ParseBool(strings.TrimSpace(raw))
			if err != nil {
				return apierr.Wrap(apierr.CodeValidationFailed, key+" must be a boolean", err)
			}
			config.Set(key, b)
		case SettingTypeNumber:
			n, err := strconv.Atoi(strings.TrimSpace(raw))
			if err != nil {
				return apierr.Wrap(apierr.CodeValidationFailed, key+" must be a number", err)
			}
			config.Set(key, n)
		default:
			value := strings.TrimSpace(raw)
			if key == "WebHostName" || key == "PterodactylHostname" {
				value = strings.TrimRight(value, "/")
			}
			config.Set(key, value)
		}
	}
	if err := config.Save(); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot write the configuration", err)
	}
	// The datastores read their connection settings at connect time, so they are
	// torn down and rebuilt for the new values to take effect.
	store.Reset()
	if err := store.Init(); err != nil {
		glgf.Error("admin: cannot reconnect to mongodb: ", err)
	}
	redis.Reset()
	return nil
}

// ComponentStatus is the result of one connectivity probe.
type ComponentStatus struct {
	OK      bool   `json:"ok"`
	Message string `json:"message"`
}

// Health is the diagnostics panel of the settings page.
type Health struct {
	Mongo       ComponentStatus `json:"mongo"`
	Redis       ComponentStatus `json:"redis"`
	Pterodactyl ComponentStatus `json:"pterodactyl"`
	Version     string          `json:"version"`
	BuildTime   string          `json:"buildTime"`
	GoVersion   string          `json:"goVersion"`
}

// Health probes every external dependency and reports the build metadata. A
// failure never fails the request: the operator asked for the state of the
// system, so the state is what they get.
func (AdminService) Health(ctx context.Context) *Health {
	h := &Health{
		Version:   buildinfo.Version,
		BuildTime: buildinfo.BuildTime,
		GoVersion: buildinfo.GoVersion,
	}
	if client := store.Client(); client == nil {
		h.Mongo = ComponentStatus{Message: "not connected"}
	} else if err := client.Ping(ctx, nil); err != nil {
		h.Mongo = ComponentStatus{Message: err.Error()}
	} else {
		h.Mongo = ComponentStatus{OK: true, Message: "success"}
	}
	if err := redis.Ping(ctx); err != nil {
		h.Redis = ComponentStatus{Message: err.Error()}
	} else {
		h.Redis = ComponentStatus{OK: true, Message: "success"}
	}
	if err := pterodactyl.ClientFromConf().TestConnection(ctx); err != nil {
		h.Pterodactyl = ComponentStatus{Message: err.Error()}
	} else {
		h.Pterodactyl = ComponentStatus{OK: true, Message: "success"}
	}
	return h
}
