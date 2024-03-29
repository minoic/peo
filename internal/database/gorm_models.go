package database

import (
	"github.com/gofrs/uuid/v5"
	"github.com/jinzhu/gorm"
	"github.com/minoic/peo/internal/configure"
	"html/template"
	"time"
)

func init() {
	DB := Mysql()
	gorm.DefaultTableNameHandler = func(db *gorm.DB, defaultTableName string) string {
		return configure.Viper().GetString("SqlTablePrefix") + defaultTableName
	}
	DB.AutoMigrate(
		&User{},
		&WareKey{},
		&PEAdminSetting{},
		&WareSpec{},
		&RegConfirmKey{},
		&WareEntity{},
		&Message{},
		&Order{},
		&DeleteConfirm{},
		&RechargeLog{},
		&RechargeKey{},
		&WorkOrder{},
		&GalleryItem{},
		&PterodactylPassword{},
	)
	return
}

type User struct {
	gorm.Model
	Name           string `gorm:"index"`
	Email          string `gorm:"index"`
	Password       string
	Balance        uint
	IsAdmin        bool
	EmailConfirmed bool
	PteUserCreated bool
	TotalUpTime    time.Duration
	UUID           uuid.UUID `gorm:"not null;unique"`
}

type WareKey struct {
	gorm.Model
	SpecID    uint `gorm:"index"`
	KeyString string
	Exp       time.Time
}

type PEAdminSetting struct {
	gorm.Model
	KeyString string
	Value     string
}

type WareSpec struct {
	gorm.Model
	PricePerMonth     uint
	WareName          string
	WareDescription   string
	Node              int
	Memory            int
	Cpu               int
	Swap              int
	Disk              int
	Io                int
	Backups           int
	Nest              int
	Egg               int
	Discount          int
	StartOnCompletion bool
	OomDisabled       bool
	DockerImage       string
	ValidDuration     time.Duration
	DeleteDuration    time.Duration
}

type WareEntity struct {
	gorm.Model
	UserID           uint `gorm:"index"`
	SpecID           uint
	ServerExternalID string
	UserExternalID   string
	HostName         string
	// DeleteStatus = 0 : Dont need to be deleted | = 1 : Delete Email Sent
	DeleteStatus int
	ValidDate    time.Time
}

type RegConfirmKey struct {
	gorm.Model
	KeyString string
	UserName  string
	UserID    uint
	UserEmail string
	ValidTime time.Time
}

type Message struct {
	gorm.Model
	SenderName string
	ReceiverID uint `gorm:"index"`
	Text       string
	TimeText   string
	HaveRead   bool
}

type DeleteConfirm struct {
	gorm.Model
	WareID uint
}

type Order struct {
	gorm.Model
	SpecID       uint
	UserID       uint `gorm:"index"`
	AllocationID int
	OriginPrice  uint
	FinalPrice   uint
	Paid         bool
	Confirmed    bool
}

type RechargeLog struct {
	gorm.Model
	UserID     uint `gorm:"index"`
	Code       string
	Method     string
	Balance    uint
	Time       string
	OutTradeNo string `gorm:"index"`
	Status     template.HTML
}

type RechargeKey struct {
	gorm.Model
	KeyString string
	Balance   uint
	Exp       time.Time
}

type WorkOrder struct {
	gorm.Model
	UserID     uint `gorm:"index"`
	UserName   string
	OrderTitle string
	OrderText  string
	Closed     bool
}

type GalleryItem struct {
	gorm.Model
	UserID          uint `gorm:"index"`
	ItemName        string
	ItemDescription string
	Likes           uint
	ReviewPassed    bool
	ImgSource       template.URL
}

type PterodactylPassword struct {
	gorm.Model
	UserID   uint `gorm:"index"`
	Password string
}
