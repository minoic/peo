// Package models defines every persisted document in MongoDB.
//
// The layout mirrors the old MySQL schema one-to-one, with four deliberate
// differences:
//
//   - gorm.Model is replaced by the embedded Doc base (explicit _id plus the
//     createdAt/updatedAt pair).
//   - Every foreign key is a bson.ObjectID instead of a uint, because MongoDB
//     has no auto-increment counters. The rest of the system therefore also
//     addresses users, products and servers by hex ObjectID string.
//   - html/template types (template.HTML, template.URL) become plain strings;
//     trusted markup is now rendered by the Flutter client, so template
//     escaping is neither needed nor possible.
//   - GORM's soft delete is dropped: the legacy code never restored a
//     soft-deleted row, it only ever filtered them out.
package models

import (
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
)

// Collection names. Kept in one place so indexes and repositories cannot drift.
const (
	CollUsers               = "users"
	CollWareSpecs           = "ware_specs"
	CollWareEntities        = "ware_entities"
	CollWareKeys            = "ware_keys"
	CollOrders              = "orders"
	CollMessages            = "messages"
	CollGalleryItems        = "gallery_items"
	CollWorkOrders          = "work_orders"
	CollRechargeKeys        = "recharge_keys"
	CollRechargeLogs        = "recharge_logs"
	CollRegConfirmKeys      = "reg_confirm_keys"
	CollDeleteConfirms      = "delete_confirms"
	CollPterodactylPassword = "pterodactyl_passwords"
)

// AllCollections lists every collection the application owns.
var AllCollections = []string{
	CollUsers, CollWareSpecs, CollWareEntities, CollWareKeys, CollOrders,
	CollMessages, CollGalleryItems, CollWorkOrders, CollRechargeKeys,
	CollRechargeLogs, CollRegConfirmKeys, CollDeleteConfirms,
	CollPterodactylPassword,
}

// Doc is the base document embedded by every model. Embedding it (rather than
// repeating three fields fourteen times) lets the store package keep its
// generic insert/update helpers generic: they type-assert on the embedded
// method set instead of using reflection.
type Doc struct {
	ID        bson.ObjectID `bson:"_id,omitempty" json:"id"`
	CreatedAt time.Time     `bson:"createdAt" json:"createdAt"`
	UpdatedAt time.Time     `bson:"updatedAt,omitempty" json:"updatedAt,omitempty"`
}

// NewID returns a fresh ObjectID. Callers use it when a document must be
// referenced (and therefore persisted) before the insert happens.
func NewID() bson.ObjectID { return bson.NewObjectID() }

// ObjectIDFromHex parses a hex string coming from a path parameter or a JSON
// body. It is the boundary where user supplied identifiers are validated.
func ObjectIDFromHex(s string) (bson.ObjectID, error) { return bson.ObjectIDFromHex(s) }

// ObjectID is an alias for the driver's identifier type, not a distinct type, so
// a value crosses the models / store / service boundary without a conversion.
// The alias exists so that a package which only ever hands ids around -- the
// handler layer, for instance -- can name the type without importing the driver.
type ObjectID = bson.ObjectID

// NilObjectID is the zero ObjectID. `idParam` returns it alongside its failure
// flag so a handler never has to construct a zero value itself.
var NilObjectID = bson.NilObjectID

// EnsureID returns the document id, minting one if it is still zero. Repositories
// call it before insert so the returned value is always usable.
func (d *Doc) EnsureID() bson.ObjectID {
	if d.ID.IsZero() {
		d.ID = bson.NewObjectID()
	}
	return d.ID
}

// Touch stamps updatedAt.
func (d *Doc) Touch() { d.UpdatedAt = time.Now() }

// StampNow stamps createdAt (when created is true) and updatedAt.
func (d *Doc) StampNow(created bool) {
	now := time.Now()
	if created || d.CreatedAt.IsZero() {
		d.CreatedAt = now
	}
	d.UpdatedAt = now
}

// IDString is a small readability helper for logging.
func (d *Doc) IDString() string { return d.ID.Hex() }

// ---------------------------------------------------------------------------
// Documents
// ---------------------------------------------------------------------------

// User is a site account. Login is name based; the name is also reused as the
// Pterodactyl panel username.
type User struct {
	Doc
	Name           string        `bson:"name" json:"name"`
	Email          string        `bson:"email" json:"email"`
	Password       string        `bson:"password" json:"-"`
	Balance        uint          `bson:"balance" json:"balance"`
	IsAdmin        bool          `bson:"isAdmin" json:"isAdmin"`
	EmailConfirmed bool          `bson:"emailConfirmed" json:"emailConfirmed"`
	PteUserCreated bool          `bson:"pteUserCreated" json:"pteUserCreated"`
	TotalUpTime    time.Duration `bson:"totalUpTime" json:"totalUpTime"`
	UUID           string        `bson:"uuid" json:"uuid"`
}

// WareSpec is a purchasable product definition. It maps almost 1:1 onto a
// Pterodactyl server-creation payload.
type WareSpec struct {
	Doc
	PricePerMonth     uint          `bson:"pricePerMonth" json:"pricePerMonth"`
	WareName          string        `bson:"wareName" json:"wareName"`
	WareDescription   string        `bson:"wareDescription" json:"wareDescription"`
	Node              int           `bson:"node" json:"node"`
	Memory            int           `bson:"memory" json:"memory"`
	Cpu               int           `bson:"cpu" json:"cpu"`
	Swap              int           `bson:"swap" json:"swap"`
	Disk              int           `bson:"disk" json:"disk"`
	Io                int           `bson:"io" json:"io"`
	Backups           int           `bson:"backups" json:"backups"`
	Nest              int           `bson:"nest" json:"nest"`
	Egg               int           `bson:"egg" json:"egg"`
	Discount          int           `bson:"discount" json:"discount"`
	StartOnCompletion bool          `bson:"startOnCompletion" json:"startOnCompletion"`
	OomDisabled       bool          `bson:"oomDisabled" json:"oomDisabled"`
	DockerImage       string        `bson:"dockerImage" json:"dockerImage"`
	ValidDuration     time.Duration `bson:"validDuration" json:"validDuration"`
	DeleteDuration    time.Duration `bson:"deleteDuration" json:"deleteDuration"`
}

// WareEntity is a purchased, provisioned server owned by a user.
type WareEntity struct {
	Doc
	UserID bson.ObjectID `bson:"userId" json:"userId"`
	SpecID bson.ObjectID `bson:"specId" json:"specId"`
	// ServerExternalID / UserExternalID keep their legacy names. UserExternalID
	// is the customer's username (legacy stored user.Name and rendered it as
	// ServerOwner in the admin console); ServerExternalID is the panel server's
	// external id, which is also its panel name.
	ServerExternalID string `bson:"serverExternalId" json:"serverExternalId"`
	UserExternalID   string `bson:"userExternalId" json:"userExternalId"`
	HostName         string `bson:"hostName" json:"hostName"`
	// DeleteStatus 0 = keep, 1 = deletion notice sent, 2 = deletion confirmed.
	DeleteStatus int       `bson:"deleteStatus" json:"deleteStatus"`
	ValidDate    time.Time `bson:"validDate" json:"validDate"`
}

// WareKey is an activation code that can be redeemed for a product.
type WareKey struct {
	Doc
	SpecID    bson.ObjectID `bson:"specId" json:"specId"`
	KeyString string        `bson:"keyString" json:"keyString"`
	Exp       time.Time     `bson:"exp" json:"exp"`
}

// RechargeKey is an activation code that tops up a balance.
type RechargeKey struct {
	Doc
	KeyString string    `bson:"keyString" json:"keyString"`
	Balance   uint      `bson:"balance" json:"balance"`
	Exp       time.Time `bson:"exp" json:"exp"`
}

// Order is a purchase intent. Confirmed implies paid.
type Order struct {
	Doc
	SpecID       bson.ObjectID `bson:"specId" json:"specId"`
	UserID       bson.ObjectID `bson:"userId" json:"userId"`
	AllocationID int           `bson:"allocationId" json:"allocationId"`
	OriginPrice  uint          `bson:"originPrice" json:"originPrice"`
	FinalPrice   uint          `bson:"finalPrice" json:"finalPrice"`
	Paid         bool          `bson:"paid" json:"paid"`
	Confirmed    bool          `bson:"confirmed" json:"confirmed"`
}

// Order status values exposed by the API.
const (
	OrderStatusPending   = "pending"
	OrderStatusPaid      = "paid"
	OrderStatusConfirmed = "confirmed"
)

// Message is an internal mail between the site and a user.
type Message struct {
	Doc
	SenderName string        `bson:"senderName" json:"senderName"`
	ReceiverID bson.ObjectID `bson:"receiverId" json:"receiverId"`
	Text       string        `bson:"text" json:"text"`
	TimeText   string        `bson:"timeText" json:"timeText"`
	HaveRead   bool          `bson:"haveRead" json:"haveRead"`
}

// GalleryItem is a user submitted screenshot shown in the public gallery.
type GalleryItem struct {
	Doc
	UserID          bson.ObjectID `bson:"userId" json:"userId"`
	ItemName        string        `bson:"itemName" json:"itemName"`
	ItemDescription string        `bson:"itemDescription" json:"itemDescription"`
	Likes           uint          `bson:"likes" json:"likes"`
	ReviewPassed    bool          `bson:"reviewPassed" json:"reviewPassed"`
	ImgSource       string        `bson:"imgSource" json:"imgSource"`
}

// WorkOrder is a support ticket. Closed tickets are hidden from the admin list.
type WorkOrder struct {
	Doc
	UserID     bson.ObjectID `bson:"userId" json:"userId"`
	UserName   string        `bson:"userName" json:"userName"`
	OrderTitle string        `bson:"orderTitle" json:"orderTitle"`
	OrderText  string        `bson:"orderText" json:"orderText"`
	Closed     bool          `bson:"closed" json:"closed"`
}

// RechargeLog records a single balance top-up attempt. Status is the enum
// defined beside the recharge service (service.RechargePending and friends)
// rather than an enum type here, because the value is written and compared in
// the same package that performs the top-up. It replaces the legacy column,
// which stored a rendered Bootstrap badge.
type RechargeLog struct {
	Doc
	UserID     bson.ObjectID `bson:"userId" json:"userId"`
	Code       string        `bson:"code" json:"code"`
	Method     string        `bson:"method" json:"method"`
	Balance    uint          `bson:"balance" json:"balance"`
	Time       string        `bson:"time" json:"time"`
	OutTradeNo string        `bson:"outTradeNo" json:"outTradeNo"`
	Status     string        `bson:"status" json:"status"`
}

// RegConfirmKey is the e-mail confirmation token issued at registration.
type RegConfirmKey struct {
	Doc
	KeyString string        `bson:"keyString" json:"keyString"`
	UserName  string        `bson:"userName" json:"userName"`
	UserID    bson.ObjectID `bson:"userId" json:"userId"`
	UserEmail string        `bson:"userEmail" json:"userEmail"`
	ValidTime time.Time     `bson:"validTime" json:"validTime"`
}

// DeleteConfirm marks a server whose owner confirmed it may be destroyed.
type DeleteConfirm struct {
	Doc
	WareID bson.ObjectID `bson:"wareId" json:"wareId"`
}

// PterodactylPassword caches the panel password used for single sign-on
// handover to the Pterodactyl front end.
type PterodactylPassword struct {
	Doc
	UserID   bson.ObjectID `bson:"userId" json:"userId"`
	Password string        `bson:"password" json:"-"`
}
