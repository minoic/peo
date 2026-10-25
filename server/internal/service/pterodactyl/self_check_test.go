package pterodactyl

import (
	"context"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/models"
)

func TestGracePeriodUsesFixedLegacyWindow(t *testing.T) {
	if got, want := GracePeriod(context.Background(), &models.WareEntity{}), 10*24*time.Hour; got != want {
		t.Fatalf("GracePeriod() = %s, want %s", got, want)
	}
}
