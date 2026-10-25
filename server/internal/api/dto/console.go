package dto

import "github.com/minoic/peo/server/internal/service"

type EmptyRequest struct{}
type ConsolePowerRequest struct {
	Signal string `json:"signal" binding:"required"`
}
type ConsoleCommandRequest struct {
	Command string `json:"command" binding:"required"`
}
type ConsoleFileReadRequest struct {
	File string `json:"file" binding:"required"`
}
type ConsoleFileWriteRequest struct {
	File    string `json:"file" binding:"required"`
	Content string `json:"content"`
}
type ConsoleFileListResponse struct {
	Items []service.ConsoleFile `json:"items"`
}
type ConsoleFileContentResponse struct {
	Content string `json:"content"`
}
type ConsoleBackupListResponse struct {
	Items []service.ConsoleBackup `json:"items"`
}
type ConsoleBackupResponse struct {
	Backup service.ConsoleBackup `json:"backup"`
}
type ConsoleBackupCreateRequest struct {
	Name string `json:"name"`
}
type ConsoleStartupVariableRequest struct {
	Key   string `json:"key" binding:"required"`
	Value string `json:"value"`
}
type ConsoleStartupImageRequest struct {
	Image string `json:"image" binding:"required"`
}
type ConsoleStartupResponse struct {
	Startup service.ConsoleStartup `json:"startup"`
}
