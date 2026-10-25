package handlers

import (
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
)

func TestStreamDeadlinesAllowSlowUploadAndResponse(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.PUT("/stream", func(c *gin.Context) {
		if err := clearStreamDeadlines(c.Writer, true, true); err != nil {
			c.String(http.StatusInternalServerError, "deadline reset failed")
			return
		}

		body, err := io.ReadAll(c.Request.Body)
		if err != nil {
			c.String(http.StatusBadRequest, "request body failed")
			return
		}
		time.Sleep(100 * time.Millisecond)
		c.Data(http.StatusOK, "application/octet-stream", body)
	})

	server := httptest.NewUnstartedServer(router)
	server.Config.ReadTimeout = 40 * time.Millisecond
	server.Config.WriteTimeout = 40 * time.Millisecond
	server.Start()
	t.Cleanup(server.Close)

	reader, writer := io.Pipe()
	request, err := http.NewRequest(http.MethodPut, server.URL+"/stream", reader)
	if err != nil {
		t.Fatal(err)
	}
	client := &http.Client{Timeout: 3 * time.Second}
	writeDone := make(chan error, 1)
	go func() {
		if _, err := writer.Write([]byte("first-")); err != nil {
			writeDone <- err
			return
		}
		time.Sleep(100 * time.Millisecond)
		if _, err := writer.Write([]byte("second")); err != nil {
			writeDone <- err
			return
		}
		writeDone <- writer.Close()
	}()

	response, err := client.Do(request)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	responseBody, err := io.ReadAll(response.Body)
	if err != nil {
		t.Fatal(err)
	}
	if err := <-writeDone; err != nil {
		t.Fatal(err)
	}
	if response.StatusCode != http.StatusOK {
		t.Fatalf("status = %d, body = %q", response.StatusCode, responseBody)
	}
	if got, want := string(responseBody), "first-second"; got != want {
		t.Fatalf("response body = %q, want %q", got, want)
	}
}

func TestInterruptedDownloadAbortsHTTP1AndHTTP2Streams(t *testing.T) {
	for _, http2 := range []bool{false, true} {
		name := "http1"
		if http2 {
			name = "http2"
		}
		t.Run(name, func(t *testing.T) {
			gin.SetMode(gin.TestMode)
			router := gin.New()
			router.GET("/download", func(c *gin.Context) {
				c.Header("Content-Length", "6")
				written, err := io.Copy(c.Writer, strings.NewReader("abc"))
				if err == nil && written != 6 {
					err = io.ErrUnexpectedEOF
				}
				if err != nil {
					panic(http.ErrAbortHandler)
				}
			})
			server := httptest.NewUnstartedServer(router)
			server.EnableHTTP2 = http2
			if http2 {
				server.StartTLS()
			} else {
				server.Start()
			}
			t.Cleanup(server.Close)
			client := server.Client()
			response, err := client.Get(server.URL + "/download")
			if err != nil {
				var urlError *url.Error
				if !errors.As(err, &urlError) {
					t.Fatalf("request error = %v", err)
				}
				return
			}
			defer response.Body.Close()
			_, err = io.ReadAll(response.Body)
			if err == nil {
				t.Fatal("truncated response was reported as complete")
			}
		})
	}
}
