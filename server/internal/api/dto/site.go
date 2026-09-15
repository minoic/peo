package dto

import (
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// SiteConfigResponse is the public bootstrap payload the Flutter shell fetches
// before it draws anything: site identity, feature switches, the socials and, for
// a signed-in visitor, the three pieces of state the legacy navigation bar
// rendered on every page.
type SiteConfigResponse struct {
	ApplicationName string `json:"applicationName"`
	Description     string `json:"description"`
	HostName        string `json:"hostName"`
	AdminAddress    string `json:"adminAddress"`
	AlbumEnabled    bool   `json:"albumEnabled"`
	RechargeMode    bool   `json:"rechargeMode"`
	AlipayEnabled   bool   `json:"alipayEnabled"`
	TotalDiscount   bool   `json:"totalDiscount"`
	SocialLink      string `json:"socialLink"`
	SocialTitle     string `json:"socialLinkTitle"`
	// EmailNotice mirrors the storefront flag: the site mails the customer
	// before an idle server is removed.
	EmailNotice bool `json:"emailNotice"`
	// LoggedIn, IsAdmin and Unread describe the caller and are always present so
	// the shell can build the navigation bar from one request. They are false and
	// zero for an anonymous visitor.
	LoggedIn bool  `json:"loggedIn"`
	IsAdmin  bool  `json:"isAdmin"`
	Unread   int64 `json:"unread"`
}

// StorefrontResponse is the shop landing page: one bucket per billing cycle.
type StorefrontResponse struct {
	Monthly     []service.ProductCard `json:"monthly"`
	Quarterly   []service.ProductCard `json:"quarterly"`
	Yearly      []service.ProductCard `json:"yearly"`
	EmailNotice bool                  `json:"emailNotice"`
}

// ProductDetailResponse is a single product with live pricing.
type ProductDetailResponse struct {
	Product  service.ProductCard `json:"product"`
	Pricing  service.Pricing     `json:"pricing"`
	NestName string              `json:"nestName,omitempty"`
	EggName  string              `json:"eggName,omitempty"`
	Eggs     []service.Egg       `json:"eggs,omitempty"`
}

// ProductListResponse is the raw specification list used by the admin product
// editor and by the order wizard when it needs the untouched record.
type ProductListResponse struct {
	Products []models.WareSpec `json:"products"`
}

// EggListResponse lists the eggs a nest offers, for the reinstall picker.
type EggListResponse struct {
	Eggs []service.Egg `json:"eggs"`
}
