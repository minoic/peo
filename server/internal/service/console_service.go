package service

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/url"
	"path"
	"strings"
	"sync"
	"time"

	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

const terminalTicketTTL = 30 * time.Second

type ConsoleService struct {
	loadEntity    func(context.Context, bson.ObjectID) (*models.WareEntity, error)
	loadUser      func(context.Context, bson.ObjectID) (*models.User, error)
	tokenRevoked  func(context.Context, string) bool
	terminalState *terminalSessions
}

var Console = ConsoleService{}

type ConsoleVariable struct {
	Key          string `json:"key"`
	Name         string `json:"name"`
	Description  string `json:"description"`
	Value        string `json:"value"`
	DefaultValue string `json:"defaultValue"`
	IsEditable   bool   `json:"isEditable"`
	Rules        string `json:"rules"`
}
type ConsoleStartup struct {
	Command      string            `json:"command"`
	Variables    []ConsoleVariable `json:"variables"`
	DockerImages map[string]string `json:"dockerImages"`
	DockerImage  string            `json:"dockerImage"`
}
type ConsoleMetadata struct {
	Server struct {
		ID         string `json:"id"`
		Identifier string `json:"identifier"`
		Name       string `json:"name"`
		Status     string `json:"status"`
		Suspended  bool   `json:"suspended"`
		Installing bool   `json:"installing"`
	} `json:"server"`
	Limits struct {
		Memory  int    `json:"memory"`
		Disk    int    `json:"disk"`
		CPU     int    `json:"cpu"`
		IO      int    `json:"io"`
		Swap    int    `json:"swap"`
		Threads string `json:"threads"`
		Backups int    `json:"backups"`
	} `json:"limits"`
	Startup ConsoleStartup `json:"startup"`
}
type ConsoleResources struct {
	CurrentState string `json:"currentState"`
	IsSuspended  bool   `json:"isSuspended"`
	Resources    struct {
		MemoryBytes    int64   `json:"memoryBytes"`
		CPUAbsolute    float64 `json:"cpuAbsolute"`
		DiskBytes      int64   `json:"diskBytes"`
		NetworkRXBytes int64   `json:"networkRxBytes"`
		NetworkTXBytes int64   `json:"networkTxBytes"`
		Uptime         int64   `json:"uptime"`
	} `json:"resources"`
}
type ConsoleFile struct {
	Name       string `json:"name"`
	Mode       string `json:"mode"`
	ModeBits   string `json:"modeBits"`
	Size       int64  `json:"size"`
	IsFile     bool   `json:"isFile"`
	IsSymlink  bool   `json:"isSymlink"`
	IsEditable bool   `json:"isEditable"`
	MimeType   string `json:"mimeType"`
	CreatedAt  string `json:"createdAt"`
	ModifiedAt string `json:"modifiedAt"`
}
type ConsoleBackup struct {
	UUID      string `json:"uuid"`
	Name      string `json:"name"`
	Bytes     int64  `json:"bytes"`
	Completed bool   `json:"completed"`
	Locked    bool   `json:"locked"`
	CreatedAt string `json:"createdAt"`
	Checksum  string `json:"checksum"`
	Status    string `json:"status"`
	Progress  int    `json:"progress"`
}

type ConsoleStream struct {
	Body          io.ReadCloser
	Filename      string
	ContentType   string
	ContentLength int64
}

func (s ConsoleService) entity(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) (*models.WareEntity, error) {
	var e *models.WareEntity
	var err error
	if s.loadEntity != nil {
		e, err = s.loadEntity(ctx, entityID)
	} else {
		e, err = store.Entity.ByID(ctx, entityID)
	}
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "server not found", err)
	}
	if e.UserID != userID && !isAdmin {
		return nil, apierr.Fail(apierr.CodeForbidden, "this server belongs to another account")
	}
	return e, nil
}

func (s ConsoleService) target(ctx context.Context, entityID, userID bson.ObjectID, isAdmin bool) (*models.WareEntity, string, pterodactyl.BridgeClient, error) {
	e, err := s.entity(ctx, entityID, userID, isAdmin)
	if err != nil {
		return nil, "", pterodactyl.BridgeClient{}, err
	}
	bridge := pterodactyl.BridgeClientFromConf()
	if err := bridge.CheckCapabilities(ctx); err != nil {
		return nil, "", pterodactyl.BridgeClient{}, panelErr("cannot validate the configured Panel extension", err)
	}
	server, err := pterodactyl.ClientFromConf().GetServer(ctx, e.ServerExternalID)
	if err != nil || server.Uuid == "" {
		return nil, "", pterodactyl.BridgeClient{}, apierr.Wrap(apierr.CodePanelUnavailable, "cannot resolve the panel server", err)
	}
	return e, server.Uuid, *bridge, nil
}

func panelErr(message string, err error) error {
	if err == nil {
		return nil
	}
	var be *pterodactyl.BridgeError
	var protocolErr *pterodactyl.BridgeProtocolError
	if errors.As(err, &protocolErr) {
		return apierr.Wrap(apierr.CodeExtensionUnavailable, "the configured PEO Panel extension is incompatible", err)
	}
	if errors.As(err, &be) {
		switch be.StatusCode {
		case 401:
			return apierr.Wrap(apierr.CodePanelUnavailable, "the configured Panel API token is invalid", err)
		case 403:
			return apierr.Wrap(apierr.CodePanelPermissionDenied, "the configured Panel API token lacks extension permissions", err)
		case 404:
			return apierr.Wrap(apierr.CodeExtensionUnavailable, "the PEO Panel extension is unavailable or disabled", err)
		case 501:
			return apierr.Wrap(apierr.CodeExtensionUnavailable, "the PEO Panel extension does not support this operation", err)
		}
	}
	return apierr.Wrap(apierr.CodePanelUnavailable, message, err)
}

func (s ConsoleService) Metadata(ctx context.Context, id, user bson.ObjectID, admin bool) (*ConsoleMetadata, error) {
	_, uuid, bridge, err := s.target(ctx, id, user, admin)
	if err != nil {
		return nil, err
	}
	v, err := bridge.Server(ctx, uuid)
	if err != nil {
		return nil, panelErr("cannot load console metadata", err)
	}
	out := &ConsoleMetadata{}
	out.Server.ID = id.Hex()
	out.Server.Identifier = v.Identifier
	out.Server.Name = v.Name
	out.Server.Status = v.Status
	out.Server.Suspended = v.Suspended
	out.Server.Installing = v.Installing
	out.Limits.Memory = v.Limits.Memory
	out.Limits.Disk = v.Limits.Disk
	out.Limits.CPU = v.Limits.CPU
	out.Limits.IO = v.Limits.IO
	out.Limits.Swap = v.Limits.Swap
	out.Limits.Threads = v.Limits.Threads
	out.Limits.Backups = v.FeatureLimits.Backups
	out.Startup.Command = v.Startup.Command
	out.Startup.DockerImages = v.Egg.DockerImages
	out.Startup.DockerImage = v.DockerImage
	out.Startup.Variables = make([]ConsoleVariable, 0, len(v.Startup.Variables))
	for _, x := range v.Startup.Variables {
		out.Startup.Variables = append(out.Startup.Variables, ConsoleVariable{Key: x.Key, Name: x.Key, Value: x.Value, DefaultValue: x.DefaultValue, IsEditable: x.Editable, Rules: x.Rules})
	}
	return out, nil
}

func (s ConsoleService) Resources(ctx context.Context, id, user bson.ObjectID, admin bool) (ConsoleResources, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return ConsoleResources{}, err
	}
	v, err := b.Resources(ctx, uuid)
	if err != nil {
		return ConsoleResources{}, panelErr("cannot load server resources", err)
	}
	var out ConsoleResources
	out.CurrentState = v.CurrentState
	out.IsSuspended = v.IsSuspended
	out.Resources.MemoryBytes = v.Resources.MemoryBytes
	out.Resources.CPUAbsolute = v.Resources.CPUAbsolute
	out.Resources.DiskBytes = v.Resources.DiskBytes
	out.Resources.NetworkRXBytes = v.Resources.NetworkRXBytes
	out.Resources.NetworkTXBytes = v.Resources.NetworkTXBytes
	out.Resources.Uptime = v.Resources.Uptime
	return out, nil
}

func (s ConsoleService) Power(ctx context.Context, id, user bson.ObjectID, admin bool, signal string) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	switch signal {
	case "start", "stop", "restart", "kill":
	default:
		return apierr.Fail(apierr.CodeValidationFailed, "unsupported power signal")
	}
	return panelErr("power command failed", b.Power(ctx, uuid, signal))
}
func (s ConsoleService) Command(ctx context.Context, id, user bson.ObjectID, admin bool, command string) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	if strings.TrimSpace(command) == "" || len(command) > 4096 {
		return apierr.Fail(apierr.CodeValidationFailed, "command is empty or too long")
	}
	return panelErr("command could not be sent", b.Command(ctx, uuid, command))
}

func cleanPanelPath(value string) (string, error) {
	if strings.ContainsRune(value, 0) || strings.Contains(value, "\\") {
		return "", apierr.Fail(apierr.CodeValidationFailed, "invalid file path")
	}
	for _, part := range strings.Split(value, "/") {
		if part == ".." {
			return "", apierr.Fail(apierr.CodeValidationFailed, "file path cannot leave the server root")
		}
	}
	clean := path.Clean("/" + value)
	if clean == "." {
		clean = "/"
	}
	return clean, nil
}
func (s ConsoleService) Files(ctx context.Context, id, user bson.ObjectID, admin bool, dir string) ([]ConsoleFile, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return nil, err
	}
	dir, err = cleanPanelPath(dir)
	if err != nil {
		return nil, err
	}
	items, err := b.FileList(ctx, uuid, dir)
	if err != nil {
		return nil, panelErr("cannot list server files", err)
	}
	out := make([]ConsoleFile, 0, len(items))
	for _, v := range items {
		out = append(out, ConsoleFile{Name: v.Name, Mode: v.Mode, ModeBits: v.ModeBits, Size: v.Size, IsFile: v.IsFile, IsSymlink: v.IsSymlink, IsEditable: v.IsEditable, MimeType: v.MimeType, CreatedAt: v.CreatedAt, ModifiedAt: v.ModifiedAt})
	}
	return out, nil
}
func (s ConsoleService) ReadFile(ctx context.Context, id, user bson.ObjectID, admin bool, file string) (string, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return "", err
	}
	file, err = cleanPanelPath(file)
	if err != nil {
		return "", err
	}
	v, err := b.FileContents(ctx, uuid, file)
	if err != nil {
		return "", panelErr("cannot read server file", err)
	}
	if len(v) > 2<<20 {
		return "", apierr.Fail(apierr.CodeValidationFailed, "text files are limited to 2 MiB")
	}
	return v, nil
}
func (s ConsoleService) FileAction(ctx context.Context, id, user bson.ObjectID, admin bool, action string, body any) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	payload, ok := body.(map[string]any)
	if !ok {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation payload")
	}
	if err := validateFileAction(action, payload); err != nil {
		return err
	}
	return panelErr("file operation failed", b.FileAction(ctx, uuid, action, body))
}

func validateFileAction(action string, body map[string]any) error {
	cleanField := func(key string) error {
		value, ok := body[key].(string)
		if !ok || strings.TrimSpace(value) == "" {
			return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation path")
		}
		clean, err := cleanPanelPath(value)
		if err != nil {
			return err
		}
		body[key] = clean
		return nil
	}
	cleanFiles := func(allowPairs, allowModes bool) error {
		files, ok := body["files"].([]any)
		if !ok || len(files) == 0 || len(files) > 100 {
			return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation paths")
		}
		for i, item := range files {
			switch value := item.(type) {
			case string:
				clean, err := cleanPanelPath(value)
				if err != nil {
					return err
				}
				files[i] = strings.TrimPrefix(clean, "/")
			case map[string]any:
				if allowPairs {
					for _, key := range []string{"from", "to"} {
						clean, err := cleanPanelPath(fmt.Sprint(value[key]))
						if _, exists := value[key]; !exists || err != nil {
							return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation path")
						}
						value[key] = strings.TrimPrefix(clean, "/")
					}
				} else {
					clean, err := cleanPanelPath(fmt.Sprint(value["file"]))
					if _, exists := value["file"]; !exists || err != nil {
						return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation path")
					}
					value["file"] = strings.TrimPrefix(clean, "/")
					if allowModes {
						mode, ok := value["mode"].(string)
						if !ok || mode == "" || len(mode) > 4 {
							return apierr.Fail(apierr.CodeValidationFailed, "invalid file mode")
						}
						for _, digit := range mode {
							if digit < '0' || digit > '7' {
								return apierr.Fail(apierr.CodeValidationFailed, "invalid file mode")
							}
						}
					}
				}
			default:
				return apierr.Fail(apierr.CodeValidationFailed, "invalid file operation paths")
			}
		}
		body["files"] = files
		return nil
	}
	if action == "copy" {
		return cleanField("location")
	}
	if err := cleanField("root"); err != nil {
		return err
	}
	switch action {
	case "mkdir":
		name, ok := body["name"].(string)
		if !ok || name == "" || name == "." || name == ".." || strings.ContainsAny(name, "/\\\x00") {
			return apierr.Fail(apierr.CodeValidationFailed, "invalid folder name")
		}
	case "rename":
		return cleanFiles(true, false)
	case "compress", "delete":
		return cleanFiles(false, false)
	case "decompress":
		return cleanField("file")
	case "chmod":
		return cleanFiles(false, true)
	default:
		return apierr.Fail(apierr.CodeValidationFailed, "unsupported file operation")
	}
	return nil
}
func (s ConsoleService) WriteFile(ctx context.Context, id, user bson.ObjectID, admin bool, file, content string) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	file, err = cleanPanelPath(file)
	if err != nil {
		return err
	}
	if len(content) > 2<<20 {
		return apierr.Fail(apierr.CodeValidationFailed, "text files are limited to 2 MiB")
	}
	return panelErr("cannot save server file", b.WriteFile(ctx, uuid, file, content))
}

func (s ConsoleService) Backups(ctx context.Context, id, user bson.ObjectID, admin bool) ([]ConsoleBackup, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return nil, err
	}
	items, err := b.Backups(ctx, uuid)
	if err != nil {
		return nil, panelErr("cannot list backups", err)
	}
	out := make([]ConsoleBackup, 0, len(items))
	for _, x := range items {
		out = append(out, ConsoleBackup{UUID: x.UUID, Name: x.Name, Bytes: x.Bytes, Completed: x.Completed, Locked: x.Locked, CreatedAt: x.CreatedAt, Checksum: x.Checksum, Status: x.Status, Progress: x.Progress})
	}
	return out, nil
}

func backupBelongsToServer(backups []pterodactyl.BridgeBackup, backupID string) bool {
	for _, backup := range backups {
		if backup.UUID == backupID {
			return true
		}
	}
	return false
}

func verifyBackupBelongsToServer(ctx context.Context, bridge *pterodactyl.BridgeClient, serverUUID, backupID string) error {
	backups, err := bridge.Backups(ctx, serverUUID)
	if err != nil {
		return panelErr("cannot verify backup ownership", err)
	}
	if !backupBelongsToServer(backups, backupID) {
		return apierr.Fail(apierr.CodeNotFound, "backup not found for this server")
	}
	return nil
}

func (s ConsoleService) CreateBackup(ctx context.Context, id, user bson.ObjectID, admin bool, name string) (ConsoleBackup, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return ConsoleBackup{}, err
	}
	if len(name) > 191 {
		return ConsoleBackup{}, apierr.Fail(apierr.CodeValidationFailed, "backup name is too long")
	}
	server, err := b.Server(ctx, uuid)
	if err != nil {
		return ConsoleBackup{}, panelErr("cannot read backup limits", err)
	}
	backups, err := b.Backups(ctx, uuid)
	if err != nil {
		return ConsoleBackup{}, panelErr("cannot read existing backups", err)
	}
	if server.FeatureLimits.Backups > 0 && len(backups) >= server.FeatureLimits.Backups {
		return ConsoleBackup{}, apierr.Fail(apierr.CodeConflict, "server backup limit has been reached")
	}
	x, err := b.CreateBackup(ctx, uuid, name)
	if err != nil {
		return ConsoleBackup{}, panelErr("cannot create backup", err)
	}
	return ConsoleBackup{UUID: x.UUID, Name: x.Name, Bytes: x.Bytes, Completed: x.Completed, Locked: x.Locked, CreatedAt: x.CreatedAt, Checksum: x.Checksum, Status: x.Status, Progress: x.Progress}, nil
}
func (s ConsoleService) BackupAction(ctx context.Context, id, user bson.ObjectID, admin bool, backupID, action string, body any) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	if len(backupID) < 8 || len(backupID) > 64 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid backup id")
	}
	if err := verifyBackupBelongsToServer(ctx, &b, uuid, backupID); err != nil {
		return err
	}
	switch action {
	case "lock", "restore":
	default:
		return apierr.Fail(apierr.CodeValidationFailed, "unsupported backup operation")
	}
	if action == "restore" {
		state, e := b.Resources(ctx, uuid)
		if e != nil {
			return panelErr("cannot verify server state before restoring", e)
		}
		if state.CurrentState != "offline" && state.CurrentState != "stopped" {
			return apierr.Fail(apierr.CodeConflict, "stop the server before restoring a backup")
		}
	}
	return panelErr("backup operation failed", b.BackupAction(ctx, uuid, backupID, action, body))
}
func (s ConsoleService) DeleteBackup(ctx context.Context, id, user bson.ObjectID, admin bool, backupID string) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	if len(backupID) < 8 || len(backupID) > 64 {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid backup id")
	}
	if err := verifyBackupBelongsToServer(ctx, &b, uuid, backupID); err != nil {
		return err
	}
	return panelErr("cannot delete backup", b.DeleteBackup(ctx, uuid, backupID))
}
func (s ConsoleService) StartupVariable(ctx context.Context, id, user bson.ObjectID, admin bool, key, value string) error {
	e, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	_ = e
	meta, err := b.Server(ctx, uuid)
	if err != nil {
		return panelErr("cannot read startup variables", err)
	}
	editable := false
	for _, v := range meta.Startup.Variables {
		if v.Key == key && v.Editable {
			editable = true
			break
		}
	}
	if !editable {
		return apierr.Fail(apierr.CodeForbidden, "startup variable is read-only or unavailable")
	}
	if len(value) > 8192 {
		return apierr.Fail(apierr.CodeValidationFailed, "startup value is too long")
	}
	return panelErr("cannot update startup variable", b.UpdateVariable(ctx, uuid, key, value))
}
func (s ConsoleService) StartupImage(ctx context.Context, id, user bson.ObjectID, admin bool, image string) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	meta, err := b.Server(ctx, uuid)
	if err != nil {
		return panelErr("cannot read startup images", err)
	}
	allowed := false
	for selected := range meta.Egg.DockerImages {
		if selected == image {
			allowed = true
			break
		}
	}
	if !allowed {
		return apierr.Fail(apierr.CodeValidationFailed, "image is not allowed by this Egg")
	}
	return panelErr("cannot update startup image", b.UpdateImage(ctx, uuid, image))
}
func (s ConsoleService) Startup(ctx context.Context, id, user bson.ObjectID, admin bool) (ConsoleStartup, error) {
	meta, err := s.Metadata(ctx, id, user, admin)
	if err != nil {
		return ConsoleStartup{}, err
	}
	return meta.Startup, nil
}

func (s ConsoleService) PrepareFileDownload(ctx context.Context, id, user bson.ObjectID, admin bool, file string) (ConsoleStream, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return ConsoleStream{}, err
	}
	file, err = cleanPanelPath(file)
	if err != nil {
		return ConsoleStream{}, err
	}
	link, err := b.FileURL(ctx, uuid, "download", file)
	if err != nil {
		return ConsoleStream{}, panelErr("cannot prepare file download", err)
	}
	resp, err := b.OpenTrustedStream(ctx, link, http.MethodGet, "", nil, 0, false, false)
	if err != nil {
		return ConsoleStream{}, apierr.Wrap(apierr.CodePanelUnavailable, "file download failed", err)
	}
	length := resp.ContentLength
	if link.ContentLength > 0 {
		length = link.ContentLength
	}
	name := link.Filename
	if name == "" {
		name = path.Base(file)
	}
	ctype := link.ContentType
	if ctype == "" {
		ctype = "application/octet-stream"
	}
	return ConsoleStream{Body: resp.Body, Filename: name, ContentType: ctype, ContentLength: length}, nil
}
func (s ConsoleService) PrepareBackupDownload(ctx context.Context, id, user bson.ObjectID, admin bool, backupID string) (ConsoleStream, error) {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return ConsoleStream{}, err
	}
	if len(backupID) < 8 || len(backupID) > 64 {
		return ConsoleStream{}, apierr.Fail(apierr.CodeValidationFailed, "invalid backup id")
	}
	if err := verifyBackupBelongsToServer(ctx, &b, uuid, backupID); err != nil {
		return ConsoleStream{}, err
	}
	link, err := b.BackupURL(ctx, uuid, backupID)
	if err != nil {
		return ConsoleStream{}, panelErr("cannot prepare backup download", err)
	}
	resp, err := b.OpenTrustedStream(ctx, link, http.MethodGet, "", nil, 0, true, false)
	if err != nil {
		return ConsoleStream{}, apierr.Wrap(apierr.CodePanelUnavailable, "backup download failed", err)
	}
	length := resp.ContentLength
	if link.ContentLength > 0 {
		length = link.ContentLength
	}
	name := link.Filename
	if name == "" {
		name = "backup.tar.gz"
	}
	ctype := link.ContentType
	if ctype == "" {
		ctype = "application/gzip"
	}
	return ConsoleStream{Body: resp.Body, Filename: name, ContentType: ctype, ContentLength: length}, nil
}
func (s ConsoleService) UploadFile(ctx context.Context, id, user bson.ObjectID, admin bool, directory, name string, src io.ReadCloser, contentLength int64) error {
	_, uuid, b, err := s.target(ctx, id, user, admin)
	if err != nil {
		return err
	}
	directory, err = cleanPanelPath(directory)
	if err != nil {
		return err
	}
	if name == "" || path.Base(name) != name || strings.ContainsAny(name, "/\\\x00") || name == "." || name == ".." {
		return apierr.Fail(apierr.CodeValidationFailed, "invalid upload filename")
	}
	if contentLength > maxUploadBytes {
		return apierr.Fail(apierr.CodeValidationFailed, "upload exceeds the supported size limit")
	}
	link, err := b.UploadURL(ctx, uuid, directory)
	if err != nil {
		return panelErr("cannot prepare file upload", err)
	}
	return uploadFileStream(ctx, &b, link, name, src, maxUploadBytes)
}

const maxUploadBytes int64 = 10 << 30

func uploadFileStream(ctx context.Context, b *pterodactyl.BridgeClient, link pterodactyl.BridgeURL, name string, src io.ReadCloser, limit int64) error {
	return uploadFileStreamWithOpen(ctx, link, name, src, limit, func(ctx context.Context, contentType string, body io.Reader) (*http.Response, error) {
		return b.OpenTrustedStream(ctx, link, http.MethodPost, contentType, body, -1, false, false)
	})
}

func uploadFileStreamWithOpen(ctx context.Context, link pterodactyl.BridgeURL, name string, src io.ReadCloser, limit int64, open func(context.Context, string, io.Reader) (*http.Response, error)) error {
	defer src.Close()
	reader, writer := io.Pipe()
	multipartWriter := multipart.NewWriter(writer)
	done := make(chan error, 1)
	go func() {
		part, e := multipartWriter.CreateFormFile("files", name)
		if e == nil {
			_, e = copyUploadLimit(part, src, limit)
		}
		if closeErr := multipartWriter.Close(); e == nil {
			e = closeErr
		}
		_ = writer.CloseWithError(e)
		done <- e
	}()
	stopCancel := context.AfterFunc(ctx, func() {
		_ = reader.CloseWithError(ctx.Err())
		_ = src.Close()
	})
	defer stopCancel()
	resp, sendErr := open(ctx, multipartWriter.FormDataContentType(), reader)
	if sendErr != nil {
		_ = reader.CloseWithError(sendErr)
		_ = src.Close()
		streamErr := <-done
		if errors.Is(streamErr, errUploadTooLarge) {
			return apierr.Fail(apierr.CodeValidationFailed, "upload exceeds the supported size limit")
		}
		return apierr.Wrap(apierr.CodePanelUnavailable, "file upload failed", sendErr)
	}
	_ = resp.Body.Close()
	var streamErr error
	select {
	case streamErr = <-done:
	default:
		// An upstream that replies before consuming the body must not leave the
		// multipart writer blocked on the pipe or the request body.
		_ = reader.CloseWithError(io.ErrUnexpectedEOF)
		_ = src.Close()
		streamErr = <-done
	}
	if errors.Is(streamErr, errUploadTooLarge) {
		return apierr.Fail(apierr.CodeValidationFailed, "upload exceeds the supported size limit")
	}
	if streamErr != nil {
		return apierr.Wrap(apierr.CodePanelUnavailable, "file upload was interrupted", streamErr)
	}
	return nil
}

var errUploadTooLarge = errors.New("upload exceeds the supported size limit")

func copyUploadLimit(dst io.Writer, src io.Reader, limit int64) (int64, error) {
	written, err := io.Copy(dst, io.LimitReader(src, limit+1))
	if err == nil && written > limit {
		err = errUploadTooLarge
	}
	return written, err
}

type terminalTicket struct {
	User          bson.ObjectID
	Entity        bson.ObjectID
	Admin         bool
	TokenHash     [32]byte
	TokenID       string
	Expires       time.Time
	SessionExpiry time.Time
}
type terminalSessions struct {
	sync.Mutex
	tickets map[string]terminalTicket
	active  map[[32]byte]map[string]context.CancelFunc
}

var terminalState = terminalSessions{tickets: map[string]terminalTicket{}, active: map[[32]byte]map[string]context.CancelFunc{}}

func tokenDigest(token string) [32]byte { return sha256.Sum256([]byte(token)) }

func (s ConsoleService) ticketState() *terminalSessions {
	if s.terminalState != nil {
		return s.terminalState
	}
	return &terminalState
}

func (s ConsoleService) loadTicketUser(ctx context.Context, id bson.ObjectID) (*models.User, error) {
	if s.loadUser != nil {
		return s.loadUser(ctx, id)
	}
	return store.User.ByID(ctx, id)
}

func (s ConsoleService) ticketRevoked(ctx context.Context, tokenID string) bool {
	if s.tokenRevoked != nil {
		return s.tokenRevoked(ctx, tokenID)
	}
	revoked, err := redis.Revoked(ctx, auth.TokenBlacklistKey(tokenID))
	return err != nil || revoked
}

type TerminalTicket struct {
	Ticket    string    `json:"ticket"`
	ExpiresAt time.Time `json:"expiresAt"`
}

func (s ConsoleService) IssueTerminalTicket(ctx context.Context, id, user bson.ObjectID, admin bool, token string) (TerminalTicket, error) {
	_, _, _, err := s.target(ctx, id, user, admin)
	if err != nil {
		return TerminalTicket{}, err
	}
	claims, err := auth.ParseToken(token)
	if err != nil {
		return TerminalTicket{}, apierr.Fail(apierr.CodeUnauthorized, "invalid or expired token")
	}
	return createTerminalTicket(s.ticketState(), user, id, admin, token, claims, time.Now())
}

func createTerminalTicket(state *terminalSessions, user, entity bson.ObjectID, admin bool, token string, claims *auth.Claims, now time.Time) (TerminalTicket, error) {
	raw := make([]byte, 32)
	if _, err := rand.Read(raw); err != nil {
		return TerminalTicket{}, apierr.Wrap(apierr.CodeInternal, "cannot issue terminal ticket", err)
	}
	value := base64.RawURLEncoding.EncodeToString(raw)
	expires := now.Add(terminalTicketTTL)
	if claims.Expires.Before(expires) {
		expires = claims.Expires
	}
	state.Lock()
	for key, ticket := range state.tickets {
		if !now.Before(ticket.Expires) {
			delete(state.tickets, key)
		}
	}
	if len(state.tickets) >= 2048 {
		state.Unlock()
		return TerminalTicket{}, apierr.Fail(apierr.CodeRateLimited, "too many active terminal tickets")
	}
	state.tickets[value] = terminalTicket{User: user, Entity: entity, Admin: admin, TokenHash: tokenDigest(token), TokenID: claims.ID, Expires: expires, SessionExpiry: claims.Expires}
	state.Unlock()
	return TerminalTicket{Ticket: value, ExpiresAt: expires}, nil
}
func ConsumeTerminalTicket(ctx context.Context, value string) (terminalTicket, bool) {
	return Console.consumeTerminalTicket(ctx, value)
}

func (s ConsoleService) consumeTerminalTicket(ctx context.Context, value string) (terminalTicket, bool) {
	state := s.ticketState()
	state.Lock()
	t, ok := state.tickets[value]
	delete(state.tickets, value)
	state.Unlock()
	if !ok || !time.Now().Before(t.Expires) || t.TokenID == "" || s.ticketRevoked(ctx, t.TokenID) {
		return terminalTicket{}, false
	}
	u, err := s.loadTicketUser(ctx, t.User)
	if err != nil {
		return terminalTicket{}, false
	}
	e, err := s.loadEntityByID(ctx, t.Entity)
	if err != nil || (!u.IsAdmin && e.UserID != u.ID) {
		return terminalTicket{}, false
	}
	t.Admin = u.IsAdmin
	return t, true
}

func (s ConsoleService) loadEntityByID(ctx context.Context, id bson.ObjectID) (*models.WareEntity, error) {
	if s.loadEntity != nil {
		return s.loadEntity(ctx, id)
	}
	return store.Entity.ByID(ctx, id)
}
func RegisterTerminal(tokenHash [32]byte, cancel context.CancelFunc) string {
	return registerTerminal(&terminalState, tokenHash, cancel)
}

func registerTerminal(state *terminalSessions, tokenHash [32]byte, cancel context.CancelFunc) string {
	var raw [16]byte
	_, _ = rand.Read(raw[:])
	id := base64.RawURLEncoding.EncodeToString(raw[:])
	state.Lock()
	if state.active[tokenHash] == nil {
		state.active[tokenHash] = map[string]context.CancelFunc{}
	}
	state.active[tokenHash][id] = cancel
	state.Unlock()
	return id
}
func UnregisterTerminal(tokenHash [32]byte, id string) {
	unregisterTerminal(&terminalState, tokenHash, id)
}

func unregisterTerminal(state *terminalSessions, tokenHash [32]byte, id string) {
	state.Lock()
	delete(state.active[tokenHash], id)
	if len(state.active[tokenHash]) == 0 {
		delete(state.active, tokenHash)
	}
	state.Unlock()
}
func RevokeTerminalSessions(token string) {
	revokeTerminalSessions(&terminalState, token)
}

func revokeTerminalSessions(state *terminalSessions, token string) {
	hash := tokenDigest(token)
	state.Lock()
	defer state.Unlock()
	for key, t := range state.tickets {
		if t.TokenHash == hash {
			delete(state.tickets, key)
		}
	}
	for _, cancel := range state.active[hash] {
		cancel()
	}
	delete(state.active, hash)
}

type TerminalAccess struct {
	Bridge        *pterodactyl.BridgeClient
	Credentials   pterodactyl.BridgeSocket
	ServerUUID    string
	TokenHash     [32]byte
	TokenID       string
	SessionExpiry time.Time
	Context       context.Context
	Cancel        context.CancelFunc
	ActiveID      string
}

func (s ConsoleService) ConnectTerminal(ctx context.Context, entityID bson.ObjectID, ticket, origin string) (TerminalAccess, error) {
	if !s.allowedConsoleOrigin(origin) {
		return TerminalAccess{}, apierr.Fail(apierr.CodeForbidden, "websocket origin is not allowed")
	}
	t, ok := s.consumeTerminalTicket(ctx, ticket)
	if !ok {
		return TerminalAccess{}, apierr.Fail(apierr.CodeUnauthorized, "terminal ticket is invalid or expired")
	}
	sessionCtx, cancel := context.WithDeadline(ctx, t.SessionExpiry)
	activeID := registerTerminal(s.ticketState(), t.TokenHash, cancel)
	fail := func(err error) (TerminalAccess, error) {
		unregisterTerminal(s.ticketState(), t.TokenHash, activeID)
		cancel()
		return TerminalAccess{}, err
	}
	if t.Entity != entityID {
		return fail(apierr.Fail(apierr.CodeForbidden, "terminal ticket belongs to another server"))
	}
	if !time.Now().Before(t.SessionExpiry) {
		return fail(apierr.Fail(apierr.CodeUnauthorized, "login session expired"))
	}
	if TerminalTokenRevoked(sessionCtx, t.TokenID) {
		return fail(apierr.Fail(apierr.CodeUnauthorized, "login session was revoked"))
	}
	e, err := s.entity(sessionCtx, t.Entity, t.User, t.Admin)
	if err != nil {
		return fail(err)
	}
	server, err := pterodactyl.ClientFromConf().GetServer(sessionCtx, e.ServerExternalID)
	if err != nil || server.Uuid == "" {
		return fail(apierr.Wrap(apierr.CodePanelUnavailable, "cannot resolve the panel server", err))
	}
	bridge := pterodactyl.BridgeClientFromConf()
	credentials, err := bridge.Socket(sessionCtx, server.Uuid)
	if err != nil {
		return fail(panelErr("cannot open server console", err))
	}
	return TerminalAccess{Bridge: bridge, Credentials: credentials, ServerUUID: server.Uuid, TokenHash: t.TokenHash, TokenID: t.TokenID, SessionExpiry: t.SessionExpiry, Context: sessionCtx, Cancel: cancel, ActiveID: activeID}, nil
}

func TerminalTokenRevoked(ctx context.Context, tokenID string) bool {
	revoked, err := redis.Revoked(ctx, auth.TokenBlacklistKey(tokenID))
	return err != nil || revoked
}

func (s ConsoleService) allowedConsoleOrigin(raw string) bool {
	parsed, err := url.Parse(raw)
	if err != nil || parsed.Scheme == "" || parsed.Host == "" || parsed.User != nil || parsed.Path != "" || parsed.RawQuery != "" || parsed.Fragment != "" {
		return false
	}
	origin := parsed.Scheme + "://" + parsed.Host
	webOrigin, webErr := url.Parse(config.String("WebHostName"))
	if webErr == nil && webOrigin.Scheme+"://"+webOrigin.Host == origin {
		return true
	}
	for _, candidate := range strings.Split(config.String("ConsoleOrigins"), ",") {
		if strings.TrimSpace(candidate) == origin {
			return true
		}
	}
	return false
}

func (s ConsoleService) CheckConsoleOrigin(origin string) bool {
	return s.allowedConsoleOrigin(origin)
}
