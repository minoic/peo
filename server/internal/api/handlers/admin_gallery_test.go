package handlers

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestReviewGalleryRejectsUnknownActionWithoutDatabase(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.POST("/gallery/:id/:action", NewAdminHandler().ReviewGallery)
	recorder := httptest.NewRecorder()
	request := httptest.NewRequest(http.MethodPost, "/gallery/0123456789abcdef01234567/pas", nil)
	router.ServeHTTP(recorder, request)
	if recorder.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want 400; body=%s", recorder.Code, recorder.Body.String())
	}
	if !strings.Contains(recorder.Body.String(), "unknown gallery action") {
		t.Fatalf("response = %s, want validation error", recorder.Body.String())
	}
}
