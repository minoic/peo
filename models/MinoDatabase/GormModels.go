package MinoDatabase

import (
	"github.com/jinzhu/gorm"
	uuid "github.com/satori/go.uuid"
	"time"
)

type User struct {
	gorm.Model
	Name           string
	Email          string
	Password       string
	IsAdmin        bool
	EmailConfirmed bool
	UUID           uuid.UUID `gorm:"not null;unique"`
}

//todo: encrypt user`s password

type WareKey struct {
	gorm.Model
	WareID uint
	Key    string
	Exp    time.Time
}

type PEAdminSetting struct {
	gorm.Model
	Key   string
	Value string
}

type WareSpec struct {
	gorm.Model
	PricePerMonth     float32
	WareName          string
	WareDescription   string
	Memory            int
	Cpu               int
	Swap              int
	Disk              int
	Io                int
	Nest              int
	Egg               int
	StartOnCompletion bool
	OomDisabled       bool
	DockerImage       string
	ValidDuration     time.Duration
	DeleteDuration    time.Duration
}

type WareEntity struct {
	gorm.Model
	UserID           uint
	ServerExternalID string
	UserExternalID   string
	//DeleteStatus = 0 : Dont need to be deleted | = 1 : Delete Email Sent
	DeleteStatus int
	ValidDate    time.Time
}

type RegConfirmKey struct {
	gorm.Model
	Key       string
	UserName  string
	UserID    uint
	UserEmail string
	ValidTime time.Time
}
