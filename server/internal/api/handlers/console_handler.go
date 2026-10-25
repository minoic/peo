package handlers

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"mime"
	"net/http"
	"path/filepath"
	"strconv"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"golang.org/x/net/websocket"
)

type ConsoleHandler struct{}

func NewConsoleHandler() *ConsoleHandler { return &ConsoleHandler{} }

func (h *ConsoleHandler) Metadata(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	v, err := service.Console.Metadata(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, v)
}
func (h *ConsoleHandler) Resources(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	v, err := service.Console.Resources(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, v)
}
func (h *ConsoleHandler) Power(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsolePowerRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Console.Power(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.Signal); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "power command accepted"})
}
func (h *ConsoleHandler) Command(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleCommandRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Console.Command(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.Command); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "command accepted"})
}
func (h *ConsoleHandler) Ticket(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.EmptyRequest
	if c.Request.ContentLength != 0 && !bind(c, &req) {
		return
	}
	v, err := service.Console.IssueTerminalTicket(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), middleware.Token(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, v)
}
func (h *ConsoleHandler) Files(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	items, err := service.Console.Files(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.DefaultQuery("directory", "/"))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.ConsoleFileListResponse{Items: items})
}
func (h *ConsoleHandler) ReadFile(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleFileReadRequest
	if !bind(c, &req) {
		return
	}
	v, err := service.Console.ReadFile(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.File)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.ConsoleFileContentResponse{Content: v})
}
func (h *ConsoleHandler) WriteFile(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleFileWriteRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Console.WriteFile(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.File, req.Content); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "file saved"})
}
func (h *ConsoleHandler) FileAction(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req map[string]any
	if !bind(c, &req) {
		return
	}
	if err := service.Console.FileAction(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.Param("action"), req); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "file operation accepted"})
}
func (h *ConsoleHandler) Backups(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	items, err := service.Console.Backups(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.ConsoleBackupListResponse{Items: items})
}
func (h *ConsoleHandler) CreateBackup(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleBackupCreateRequest
	if !bind(c, &req) {
		return
	}
	item, err := service.Console.CreateBackup(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.Name)
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.ConsoleBackupResponse{Backup: item})
}
func (h *ConsoleHandler) BackupAction(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	action := c.Param("action")
	var req map[string]any
	if c.Request.ContentLength != 0 && !bind(c, &req) {
		return
	}
	if err := service.Console.BackupAction(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.Param("backupId"), action, req); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "backup operation accepted"})
}
func (h *ConsoleHandler) DeleteBackup(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	if err := service.Console.DeleteBackup(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.Param("backupId")); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "backup deleted"})
}
func (h *ConsoleHandler) StartupVariable(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleStartupVariableRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Console.StartupVariable(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.Key, req.Value); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "startup variable updated"})
}
func (h *ConsoleHandler) StartupImage(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ConsoleStartupImageRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Console.StartupImage(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), req.Image); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "startup image updated"})
}
func (h *ConsoleHandler) Startup(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	v, err := service.Console.Startup(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, v)
}

func (h *ConsoleHandler) DownloadFile(c *gin.Context)   { h.streamDownload(c, false) }
func (h *ConsoleHandler) DownloadBackup(c *gin.Context) { h.streamDownload(c, true) }
func (h *ConsoleHandler) streamDownload(c *gin.Context, backup bool) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	if err := clearStreamDeadlines(c.Writer, false, true); err != nil {
		fail(c, err)
		return
	}
	var out service.ConsoleStream
	var err error
	if backup {
		out, err = service.Console.PrepareBackupDownload(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.Param("backupId"))
	} else {
		out, err = service.Console.PrepareFileDownload(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), c.Query("file"))
	}
	if err != nil {
		fail(c, err)
		return
	}
	defer out.Body.Close()
	name := filepath.Base(out.Filename)
	if name == "." || name == "/" || name == "" {
		name = "download"
	}
	c.Header("Content-Disposition", mime.FormatMediaType("attachment", map[string]string{"filename": name}))
	c.Header("Content-Type", out.ContentType)
	c.Header("Trailer", "X-Stream-Error")
	if out.ContentLength >= 0 {
		c.Header("Content-Length", strconv.FormatInt(out.ContentLength, 10))
	}
	written, copyErr := io.Copy(c.Writer, out.Body)
	if copyErr == nil && out.ContentLength >= 0 && written != out.ContentLength {
		copyErr = io.ErrUnexpectedEOF
	}
	if copyErr != nil {
		glgf.Error("console: download interrupted after ", written, " bytes: ", copyErr)
		c.Writer.Header().Set("X-Stream-Error", "interrupted")
		panic(http.ErrAbortHandler)
	}
}

func (h *ConsoleHandler) UploadFile(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	if err := clearStreamDeadlines(c.Writer, true, true); err != nil {
		fail(c, err)
		return
	}
	name := c.Query("filename")
	directory := c.DefaultQuery("directory", "/")
	if err := service.Console.UploadFile(c.Request.Context(), id, middleware.UserID(c), middleware.IsAdmin(c), directory, name, c.Request.Body, c.Request.ContentLength); err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageResponse{Message: "upload complete"})
}

func clearStreamDeadlines(writer http.ResponseWriter, read, write bool) error {
	controller := http.NewResponseController(writer)
	if read {
		if err := controller.SetReadDeadline(time.Time{}); err != nil {
			return fmt.Errorf("cannot clear streaming read deadline: %w", err)
		}
	}
	if write {
		if err := controller.SetWriteDeadline(time.Time{}); err != nil {
			return fmt.Errorf("cannot clear streaming write deadline: %w", err)
		}
	}

	return nil
}

func (h *ConsoleHandler) Terminal(c *gin.Context) {
	id, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	if !service.Console.CheckConsoleOrigin(c.GetHeader("Origin")) {
		c.AbortWithStatusJSON(403, gin.H{"ok": false, "error": gin.H{"code": "forbidden", "message": "websocket origin is not allowed"}})
		return
	}
	ticket := c.Query("ticket")
	if ticket == "" {
		c.AbortWithStatusJSON(401, gin.H{"ok": false, "error": gin.H{"code": "unauthorized", "message": "terminal ticket is required"}})
		return
	}
	access, err := service.Console.ConnectTerminal(c.Request.Context(), id, ticket, c.GetHeader("Origin"))
	if err != nil {
		fail(c, err)
		return
	}
	defer service.UnregisterTerminal(access.TokenHash, access.ActiveID)
	defer access.Cancel()
	upstream, err := access.Bridge.DialSocket(access.Context, access.Credentials, access.ServerUUID)
	if err != nil {
		fail(c, err)
		return
	}
	defer upstream.Close()
	wsHandler := websocket.Server{Handler: websocket.Handler(func(client *websocket.Conn) {
		authMessage, _ := json.Marshal(map[string]any{"event": "auth", "args": []string{access.Credentials.Token}})
		if err := websocket.Message.Send(upstream, string(authMessage)); err != nil {
			upstream.Close()
			return
		}
		defer upstream.Close()
		defer client.Close()
		var closeOnce sync.Once
		closeBoth := func() {
			closeOnce.Do(func() {
				access.Cancel()
				_ = client.Close()
				_ = upstream.Close()
			})
		}
		finished := make(chan struct{}, 2)
		go func() { relayClientFrames(client, upstream); finished <- struct{}{} }()
		go func() {
			relayPanelFrames(access.Context, access.Bridge, access.ServerUUID, upstream, client)
			finished <- struct{}{}
		}()
		ticker := time.NewTicker(3 * time.Second)
		defer ticker.Stop()
		running := true
		for running {
			select {
			case <-access.Context.Done():
				running = false
			case <-finished:
				running = false
			case <-ticker.C:
				checkCtx, cancel := context.WithTimeout(access.Context, time.Second)
				revoked := service.TerminalTokenRevoked(checkCtx, access.TokenID)
				cancel()
				if revoked {
					running = false
				}
			}
		}
		closeBoth()
	}), Handshake: func(config *websocket.Config, _ *http.Request) error {
		return nil
	}}
	wsHandler.ServeHTTP(c.Writer, c.Request)
}

func relayClientFrames(from, to *websocket.Conn) {
	for {
		var payload string
		if err := websocket.Message.Receive(from, &payload); err != nil {
			return
		}
		filtered, forward := filterClientTerminalFrame(payload)
		if !forward {
			continue
		}
		if err := websocket.Message.Send(to, filtered); err != nil {
			return
		}
	}
}

func filterClientTerminalFrame(payload string) (string, bool) {
	var event struct {
		Event string            `json:"event"`
		Args  []json.RawMessage `json:"args"`
	}
	if len(payload) > 64*1024 || json.Unmarshal([]byte(payload), &event) != nil {
		return "", false
	}
	switch event.Event {
	case "send logs", "send stats":
		return payload, true
	default:
		return "", false
	}
}

func relayPanelFrames(ctx context.Context, bridge *pterodactyl.BridgeClient, serverUUID string, from, to *websocket.Conn) {
	logsRequested := false
	for {
		var payload string
		if err := websocket.Message.Receive(from, &payload); err != nil {
			return
		}
		var event struct {
			Event string `json:"event"`
		}
		if len(payload) > 64*1024 || json.Unmarshal([]byte(payload), &event) != nil {
			continue
		}
		switch event.Event {
		case "jwt error":
			return
		case "token expiring", "token expired":
			credentials, err := bridge.Socket(ctx, serverUUID)
			if err == nil {
				var authMessage []byte
				authMessage, err = json.Marshal(map[string]any{"event": "auth", "args": []string{credentials.Token}})
				if err == nil {
					err = websocket.Message.Send(from, string(authMessage))
				}
			}
			if err != nil {
				_ = websocket.Message.Send(to, `{"event":"token expiring","args":[]}`)
				return
			}
		case "console output":
			if err := websocket.Message.Send(to, payload); err != nil {
				return
			}
		case "auth success":
			if !logsRequested {
				if err := websocket.Message.Send(from, `{"event":"send logs","args":[null]}`); err != nil {
					return
				}
				logsRequested = true
			}
		default:
			// Auth and credential-bearing upstream events never cross to the browser.
		}
	}
}
