package PterodactylAPI

import "time"

type PterodactylUser struct {
	Uid        int       `json:"id"`
	ExternalId string    `json:"external_id"`
	Uuid       string    `json:"uuid"`
	UserName   string    `json:"username"`
	Email      string    `json:"email"`
	FirstName  string    `json:"first_name"`
	LastName   string    `json:"last_name"`
	Language   string    `json:"language"`
	RootAdmin  bool      `json:"root_admin"`
	TwoFA      bool      `json:"2fa"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type PterodactylNest struct {
	Id          int       `json:"id"`
	Uuid        string    `json:"uuid"`
	Author      string    `json:"author"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type PterodactylEgg struct {
	Id          int       `json:"id"`
	Uuid        string    `json:"uuid"`
	Name        string    `json:"name"`
	Nest        int       `json:"nest"`
	Author      string    `json:"author"`
	Description string    `json:"Description"`
	DockerImage string    `json:"docker_image"`
	StartUp     string    `json:"startup"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type PterodactylNode struct {
	Id                 int       `json:"id"`
	Public             bool      `json:"public"`
	Name               string    `json:"name"`
	Description        string    `json:"Description"`
	LocationId         int       `json:"location_id"`
	FQDN               string    `json:"fqdn"`
	Scheme             string    `json:"scheme"`
	BehindProxy        bool      `json:"behind_proxy"`
	MaintenanceMode    bool      `json:"maintenance_mode"`
	Memory             int       `json:"memory"`
	MemoryOverAllocate int       `json:"memory_overallocate"`
	Disk               int       `json:"disk"`
	DiskOverAllocate   int       `json:"disk_overallocate"`
	UploadSize         int       `json:"upload_size"`
	DaemonListen       int       `json:"daemon_listen"`
	DaemonSftp         int       `json:"daemon_sftp"`
	DaemonBase         string    `json:"daemon_base"`
	CreatedAt          time.Time `json:"created_at"`
	UpdatedAt          time.Time `json:"updated_at"`
}

type PterodactylAllocation struct {
	ID       int    `json:"id"`
	IP       string `json:"ip"`
	Alias    string `json:"alias"`
	Port     int    `json:"port"`
	Assigned bool   `json:"assigned"`
}

type PterodactylServerLimit struct {
	Memory int `json:"memory"`
	Swap   int `json:"swap"`
	Disk   int `json:"disk"`
	IO     int `json:"io"`
	CPU    int `json:"cpu"`
}

type PterodactylServer struct {
	Id          int                    `json:"id"`
	ExternalId  string                 `json:"external_id"`
	Uuid        string                 `json:"uuid"`
	Identifier  string                 `json:"identifier"`
	Name        string                 `json:"name"`
	Description string                 `json:"Description"`
	Suspended   bool                   `json:"suspended"`
	Limits      PterodactylServerLimit `json:"limits"`
	UserId      int                    `json:"user"`
	NodeId      int                    `json:"node"`
	Allocation  int                    `json:"allocation"`
	NestId      int                    `json:"nest"`
	EggId       int                    `json:"egg"`
	PackId      int                    `json:"pack"`
}

type PostPteUser struct {
	ExternalId string `json:"external_id"`
	Username   string `json:"username"`
	Email      string `json:"email"`
	Language   string `json:"language"`
	RootAdmin  bool   `json:"root_admin"`
	Password   string `json:"password"`
	FirstName  string `json:"first_name"`
	LastName   string `json:"last_name"`
}

type PostUpdateDetails struct {
	UserID      int
	ServerName  string
	Description string
	ExternalID  string
}

type PostUpdateBuild struct {
	Allocation  int
	CPU         int
	Memory      int
	Swap        int
	IO          int
	Disk        int
	OomDisabled bool
	Database    int
	Allocations int
}
