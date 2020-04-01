package MinoDatabase

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
	"github.com/jinzhu/gorm"
	uuid "github.com/satori/go.uuid"
	"html/template"
	"time"
)

func init() {
	DB := GetDatabase()
	gorm.DefaultTableNameHandler = func(db *gorm.DB, defaultTableName string) string {
		return MinoConfigure.SqlTablePrefix + defaultTableName
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
		&Pack{},
		&RechargeLog{},
		&RechargeKey{},
		&WorkOrder{},
		&GalleryItem{},
	)
	return
}

type User struct {
	gorm.Model
	Name           string
	Email          string
	Password       string
	Balance        uint
	IsAdmin        bool
	EmailConfirmed bool
	PteUserCreated bool
	UUID           uuid.UUID `gorm:"not null;unique"`
}

type WareKey struct {
	gorm.Model
	SpecID    uint
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
	UserID           uint
	SpecID           uint
	ServerExternalID string
	UserExternalID   string
	HostName         string
	//DeleteStatus = 0 : Dont need to be deleted | = 1 : Delete Email Sent
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
	ReceiverID uint
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
	UserID       uint
	AllocationID int
	OriginPrice  uint
	FinalPrice   uint
	Paid         bool
	Confirmed    bool
}

type Pack struct {
	gorm.Model
	PackName        string
	NestID          int
	EggID           int
	PackID          int
	PackDescription string
}

type RechargeLog struct {
	gorm.Model
	UserID  uint
	Code    string
	Method  string
	Balance uint
	Time    string
	Status  template.HTML
}

type RechargeKey struct {
	gorm.Model
	KeyString string
	Balance   uint
	Exp       time.Time
}

type WorkOrder struct {
	gorm.Model
	UserID     uint
	UserName   string
	OrderTitle string
	OrderText  string
	Closed     bool
}

type GalleryItem struct {
	gorm.Model
	UserID          uint
	ItemName        string
	ItemDescription string
	Likes           uint
	ReviewPassed    bool
	ImgSource       template.URL
}
