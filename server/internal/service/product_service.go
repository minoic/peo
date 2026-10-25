package service

import (
	"context"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// The three billing cycles the storefront groups products into. A product whose
// ValidDuration is none of these is not offered on the storefront at all, which
// is how the three day trial stays reachable only from a direct product link.
const (
	durationMonthly   = 30 * day
	durationQuarterly = 90 * day
	durationYearly    = 365 * day
)

// Intro is one bullet on a product card. The wording is owned by the client:
// it translates Key and appends Value, so the server never ships prose. Label
// carries a free-form name (the nest description, a product note) that has no
// translation and is shown verbatim.
type Intro struct {
	Key   string `json:"key,omitempty"`
	Value string `json:"value,omitempty"`
	Label string `json:"label,omitempty"`
	// Hint marks a bullet that carries an extra explanation, used for the
	// retention bullet when the site sends expiry mail.
	Hint bool `json:"hint,omitempty"`
}

// ProductCard is one purchasable product as shown on the storefront.
type ProductCard struct {
	SpecID   string  `json:"specId"`
	WareName string  `json:"wareName"`
	Discount int     `json:"discount"`
	Intros   []Intro `json:"intros"`
	// Price is the total for the billing cycle of the bucket the card sits in;
	// MonthPrice is the monthly list price before the discount.
	Price         uint   `json:"price"`
	MonthPrice    uint   `json:"monthPrice"`
	ValidDays     int    `json:"validDays"`
	DeleteDays    int    `json:"deleteDays"`
	Memory        int    `json:"memory"`
	Cpu           int    `json:"cpu"`
	Disk          int    `json:"disk"`
	Backups       int    `json:"backups"`
	Nest          int    `json:"nest"`
	Egg           int    `json:"egg"`
	TagSlug       string `json:"tagSlug,omitempty"`
	AllowedEggIDs []int  `json:"allowedEggIds"`
}

// Storefront is the grouped product catalogue.
type Storefront struct {
	Monthly   []ProductCard `json:"monthly"`
	Quarterly []ProductCard `json:"quarterly"`
	Yearly    []ProductCard `json:"yearly"`
	// EmailNotice tells the client whether to explain that the site mails the
	// customer before an idle server is removed.
	EmailNotice bool `json:"emailNotice"`
}

// ProductDetail is a single product plus its evaluated price, which is what the
// order page needs before a purchase is created.
type ProductDetail struct {
	Product  ProductCard `json:"product"`
	Pricing  Pricing     `json:"pricing"`
	NestName string      `json:"nestName,omitempty"`
	TagSlug  string      `json:"tagSlug,omitempty"`
	EggName  string      `json:"eggName,omitempty"`
	Eggs     []Egg       `json:"eggs,omitempty"`
}

// Egg is one selectable server template for a product.
type Egg struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

// ProductService owns the storefront projection. Building a card calls the panel
// for the nest description, so the result is cached and rebuilt by the cron
// rather than computed inside a request. The cache is a service field instead of
// a package variable, which is what the legacy controller used.
type ProductService struct {
	mu       sync.RWMutex
	cached   Storefront
	built    bool
	eggCache sync.Map // panel identity + tag -> expiring []Egg
}

type eggCacheEntry struct {
	eggs    []Egg
	expires time.Time
}

// Products is the default ProductService.
var Products = ProductService{}

// refreshEvery is the storefront cache lifetime, matching the legacy one minute
// cron interval.
const refreshEvery = time.Minute

// Refresh rebuilds the storefront cache. It is safe to call concurrently and is
// invoked at startup and every minute by the cron.
func (s *ProductService) Refresh(ctx context.Context) {
	front, err := s.build(ctx)
	if err != nil {
		glgf.Error("product: cannot rebuild the storefront: ", err)
		return
	}
	s.mu.Lock()
	s.cached = front
	s.built = true
	s.mu.Unlock()
}

// Storefront returns the cached catalogue, building it on first use so a cold
// process never serves an empty shop.
func (s *ProductService) Storefront(ctx context.Context) (Storefront, error) {
	s.mu.RLock()
	front, built := s.cached, s.built
	s.mu.RUnlock()
	if built {
		return front, nil
	}
	front, err := s.build(ctx)
	if err != nil {
		return Storefront{}, apierr.Wrap(apierr.CodeInternal, "cannot list the products", err)
	}
	s.mu.Lock()
	s.cached, s.built = front, true
	s.mu.Unlock()
	return front, nil
}

// build projects every product into a card and groups it by billing cycle.
func (s *ProductService) build(ctx context.Context) (Storefront, error) {
	specs, err := store.Spec.All(ctx)
	if err != nil {
		return Storefront{}, err
	}
	front := Storefront{
		Monthly:     make([]ProductCard, 0, len(specs)),
		Quarterly:   make([]ProductCard, 0, len(specs)),
		Yearly:      make([]ProductCard, 0, len(specs)),
		EmailNotice: config.Bool("SMTPEnabled"),
	}
	cli := pterodactyl.ClientFromConf()
	for i := range specs {
		spec := &specs[i]
		card := s.card(ctx, cli, spec)
		switch spec.ValidDuration {
		case durationMonthly:
			card.Price = card.MonthPrice
			front.Monthly = append(front.Monthly, card)
		case durationQuarterly:
			card.Price = card.MonthPrice * 3
			front.Quarterly = append(front.Quarterly, card)
		case durationYearly:
			card.Price = card.MonthPrice * 12
			front.Yearly = append(front.Yearly, card)
		}
	}
	return front, nil
}

// card turns a product document into the storefront representation.
func (s *ProductService) card(ctx context.Context, cli *pterodactyl.Client, spec *models.WareSpec) ProductCard {
	tagSlug := spec.TagSlug
	if tagSlug == "" && spec.PanelLegacyNestID() != 0 {
		if tag, err := cli.TagForLegacyNest(ctx, spec.PanelLegacyNestID()); err == nil {
			tagSlug = tag.Slug
		}
	}
	card := ProductCard{
		SpecID:        spec.ID.Hex(),
		WareName:      spec.WareName,
		Discount:      spec.Discount,
		Memory:        spec.Memory,
		Cpu:           spec.Cpu,
		Disk:          spec.Disk,
		Backups:       spec.Backups,
		Nest:          spec.Nest,
		Egg:           spec.Egg,
		TagSlug:       tagSlug,
		AllowedEggIDs: allowedEggs(spec),
		MonthPrice:    spec.PricePerMonth,
		ValidDays:     days(spec.ValidDuration),
		DeleteDays:    days(spec.DeleteDuration),
	}
	// When the administrator turned the site-wide discount off every card shows
	// the list price, so a stale per product percentage cannot mislead anyone.
	if !config.Bool("TotalDiscount") {
		card.Discount = 0
	}
	// The legacy card always said "Docker"; a product that names its own image
	// shows that instead.
	virtualEnv := spec.DockerImage
	if virtualEnv == "" {
		virtualEnv = "Docker"
	}
	intros := []Intro{
		{Key: "cpu", Value: strconv.Itoa(spec.Cpu / 100)},
		{Key: "memory", Value: strconv.Itoa(spec.Memory)},
		{Key: "disk", Value: strconv.Itoa(spec.Disk)},
		{Key: "backups", Value: strconv.Itoa(spec.Backups)},
		{Key: "virtualEnv", Value: virtualEnv},
	}
	if tagSlug != "" {
		if tag, err := cli.GetTag(ctx, tagSlug); err == nil && tag.Name != "" {
			intros = append(intros, Intro{Label: tag.Name})
		}
	}
	intros = append(intros, Intro{
		Key:   "retention",
		Value: strconv.Itoa(card.DeleteDays),
		Hint:  config.Bool("SMTPEnabled"),
	})
	if spec.WareDescription != "" {
		intros = append(intros, Intro{Label: spec.WareDescription})
	}
	card.Intros = intros
	return card
}

// Detail returns one product with its price and the eggs a customer may pick.
// The storefront only offers three billing cycles, but a product may be reached
// directly by id, so this works for any duration.
func (s *ProductService) Detail(ctx context.Context, specID bson.ObjectID) (*ProductDetail, error) {
	spec, err := store.Spec.ByID(ctx, specID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "product not found", err)
	}
	cli := pterodactyl.ClientFromConf()
	card := s.card(ctx, cli, spec)
	switch spec.ValidDuration {
	case durationQuarterly:
		card.Price = card.MonthPrice * 3
	case durationYearly:
		card.Price = card.MonthPrice * 12
	default:
		card.Price = card.MonthPrice
	}
	detail := &ProductDetail{Product: card, Pricing: PriceFor(spec)}
	detail.TagSlug = card.TagSlug
	if tag, err := cli.GetTag(ctx, detail.TagSlug); err == nil {
		detail.NestName = tag.Name
	}
	eggs, err := s.eggsForTag(ctx, cli, detail.TagSlug)
	if err != nil {
		glgf.Warn("product: cannot list eggs for tag ", detail.TagSlug, ": ", err)
	} else {
		allowed := make(map[int]bool, len(detail.Product.AllowedEggIDs))
		for _, id := range detail.Product.AllowedEggIDs {
			allowed[id] = true
		}
		for _, egg := range eggs {
			if allowed[egg.Id] {
				detail.Eggs = append(detail.Eggs, egg)
			}
		}
	}
	if egg, err := cli.GetEgg(ctx, 0, spec.Egg); err == nil {
		detail.EggName = egg.Name
	}
	return detail, nil
}

// Eggs lists the server templates of a nest. This replaces the legacy package
// level EggsMap, which the cron emptied and refilled behind the controllers'
// backs.
func (s *ProductService) Eggs(ctx context.Context, nestID int) ([]Egg, error) {
	cli := pterodactyl.ClientFromConf()
	tag, err := cli.TagForLegacyNest(ctx, nestID)
	if err != nil {
		return nil, err
	}
	return s.eggsForTag(ctx, cli, tag.Slug)
}

// EggsForTag lists templates assigned to one Panel 2 tag.
func (s *ProductService) EggsForTag(ctx context.Context, tagSlug string) ([]Egg, error) {
	return s.eggsForTag(ctx, pterodactyl.ClientFromConf(), tagSlug)
}

func (s *ProductService) eggsForTag(ctx context.Context, cli *pterodactyl.Client, tagSlug string) ([]Egg, error) {
	key := cli.IdentityFingerprint() + ":tag:" + tagSlug
	if cached, ok := s.eggCache.Load(key); ok {
		entry := cached.(eggCacheEntry)
		if time.Now().Before(entry.expires) {
			return entry.eggs, nil
		}
		s.eggCache.Delete(key)
	}
	raw, err := cli.GetEggsForTag(ctx, tagSlug)
	if err != nil {
		return nil, err
	}
	out := make([]Egg, 0, len(raw))
	for i := range raw {
		out = append(out, Egg{Id: raw[i].Id, Name: raw[i].Name})
	}
	s.eggCache.Store(key, eggCacheEntry{eggs: out, expires: time.Now().Add(refreshEvery)})
	return out, nil
}

// CacheEggs pre-loads the templates of every nest a product uses, so the first
// customer to open a product page does not wait for the panel. It is the port of
// the legacy CacheNeededEggs cron job.
func (s *ProductService) CacheEggs(ctx context.Context) {
	specs, err := store.Spec.All(ctx)
	if err != nil {
		glgf.Error("product: cannot list products to cache eggs: ", err)
		return
	}
	cli := pterodactyl.ClientFromConf()
	seen := make(map[string]bool, len(specs))
	for i := range specs {
		tag := specs[i].TagSlug
		if tag == "" && specs[i].PanelLegacyNestID() != 0 {
			if resolved, e := cli.TagForLegacyNest(ctx, specs[i].PanelLegacyNestID()); e == nil {
				tag = resolved.Slug
			}
		}
		if seen[tag] || tag == "" {
			continue
		}
		seen[tag] = true
		eggs, err := s.eggsForTag(ctx, cli, tag)
		if err != nil {
			glgf.Error("product: cannot cache eggs of tag ", tag, ": ", err)
			continue
		}
		glgf.Info("product: cached ", len(eggs), " eggs for tag ", tag)
	}
}

// InvalidateEggs drops the cached templates of a nest after an administrator
// changed what the panel offers.
func (s *ProductService) InvalidateEggs(nestID int) {
	// The Panel cache is keyed by identity and tag; a legacy nest ID does not
	// identify a single cached entry, so invalidate the small egg cache as a whole.
	s.eggCache.Range(func(key, _ any) bool {
		s.eggCache.Delete(key)
		return true
	})
}

func (s *ProductService) InvalidateTag(tagSlug string) {
	suffix := ":tag:" + tagSlug
	s.eggCache.Range(func(key, _ any) bool {
		if strings.HasSuffix(key.(string), suffix) {
			s.eggCache.Delete(key)
		}
		return true
	})
}

// List returns every product document, which the admin console edits.
func (s *ProductService) List(ctx context.Context) ([]models.WareSpec, error) {
	return store.Spec.All(ctx)
}

// days converts a duration to whole days for the API, since a client should not
// have to know that Go durations are nanoseconds.
func days(d time.Duration) int { return int(d.Hours() / 24) }
