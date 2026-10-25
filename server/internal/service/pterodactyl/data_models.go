package pterodactyl

import "time"

// The structs in this file mirror the JSON shapes returned by the Pterodactyl
// Application API. Panel 2.0 uses eggs and tags in place of nests.
//
// User is a panel account.
type User struct {
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

// Nest is a group of eggs.
type Nest struct {
	Id          int       `json:"id"`
	Uuid        string    `json:"uuid"`
	Author      string    `json:"author"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// ScriptInfo is the install script part of an egg.
type ScriptInfo struct {
	Privileged bool        `json:"privileged"`
	Install    string      `json:"install"`
	Entry      string      `json:"entry"`
	Container  string      `json:"container"`
	Extends    interface{} `json:"extends"`
}

// Egg is a server template.
type Egg struct {
	Id            int                    `json:"id"`
	Uuid          string                 `json:"uuid"`
	Name          string                 `json:"name"`
	Nest          int                    `json:"nest"`
	Author        string                 `json:"author"`
	Description   string                 `json:"Description"`
	DockerImage   string                 `json:"docker_image"`
	DockerImages  map[string]string      `json:"docker_images"`
	Config        map[string]interface{} `json:"config"`
	Script        ScriptInfo             `json:"script"`
	StartUp       string                 `json:"startup"`
	CreatedAt     time.Time              `json:"created_at"`
	UpdatedAt     time.Time              `json:"updated_at"`
	Relationships struct {
		Tags struct {
			Data []struct {
				Attributes Tag `json:"attributes"`
			} `json:"data"`
		} `json:"tags"`
	} `json:"relationships"`
}

// Tag groups Eggs in Panel 2.0. LegacyNestID is present only when imported from
// a Panel 1.x nest and is not assumed unique by callers.
type Tag struct {
	ID           int    `json:"id"`
	Name         string `json:"name"`
	Slug         string `json:"slug"`
	LegacyNestID *int   `json:"legacy_nest_id"`
}

// Node is a daemon host.
type Node struct {
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

// Allocation is a single ip:port slot on a node.
type Allocation struct {
	ID       int    `json:"id"`
	IP       string `json:"ip"`
	Alias    string `json:"alias"`
	Port     int    `json:"port"`
	Assigned bool   `json:"assigned"`
}

// ServerLimit holds the resource limits of a server.
type ServerLimit struct {
	Memory      int  `json:"memory"`
	Swap        int  `json:"swap"`
	Disk        int  `json:"disk"`
	IO          int  `json:"io"`
	CPU         int  `json:"cpu"`
	OOMDisabled bool `json:"oom_disabled"`
}

// FeatureLimit holds the per-server feature quotas.
type FeatureLimit struct {
	Databases   int `json:"databases"`
	Allocations int `json:"allocations"`
	Backups     int `json:"backups"`
}

// ContainerInfo is the container state of a server.
type ContainerInfo struct {
	StartupCommand string `json:"startup_command"`
	Image          string `json:"image"`
	Installed      int    `json:"installed"`
}

// Server is a panel server.
type Server struct {
	Id            int           `json:"id"`
	ExternalId    string        `json:"external_id"`
	Uuid          string        `json:"uuid"`
	Identifier    string        `json:"identifier"`
	Name          string        `json:"name"`
	Description   string        `json:"Description"`
	Suspended     bool          `json:"suspended"`
	Limits        ServerLimit   `json:"limits"`
	FeatureLimits FeatureLimit  `json:"feature_limits"`
	UserId        int           `json:"user"`
	NodeId        int           `json:"node"`
	Allocation    int           `json:"allocation"`
	NestId        int           `json:"nest"`
	EggId         int           `json:"egg"`
	TagSlug       string        `json:"-"`
	AllowedEggIDs []int         `json:"-"`
	DockerImage   string        `json:"docker_image,omitempty"`
	Container     ContainerInfo `json:"container"`
	UpdatedAt     time.Time     `json:"updated_at"`
	CreatedAt     time.Time     `json:"created_at"`
}

// PostPteUser is the request body for creating a panel user.
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

// PostUpdateDetails is the request body for PATCH servers/{id}/details.
type PostUpdateDetails struct {
	UserID      int    `json:"user_id"`
	ServerName  string `json:"server_name"`
	Description string `json:"description"`
	ExternalID  string `json:"external_id"`
}

// PostUpdateBuild is the request body for PATCH servers/{id}/build.
type PostUpdateBuild struct {
	Allocation  int  `json:"allocation"`
	CPU         int  `json:"cpu"`
	Memory      int  `json:"memory"`
	Swap        int  `json:"swap"`
	IO          int  `json:"io"`
	Disk        int  `json:"disk"`
	OomDisabled bool `json:"oom_disabled"`
	Database    int  `json:"database"`
	Allocations int  `json:"allocations"`
}
