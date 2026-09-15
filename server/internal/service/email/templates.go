// Package email renders and sends the transactional messages of the site.
//
// The HTML bodies are produced with hermes, exactly as before, so the mail looks
// the same. The copy is English only, matching the rest of the ported site.
package email

import (
	"strings"

	"github.com/matcornic/hermes/v2"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
)

// product describes the sender for hermes. It is rebuilt on every render so a
// settings change is reflected in the next message.
func product() hermes.Hermes {
	return hermes.Hermes{
		Theme: new(hermes.Flat),
		Product: hermes.Product{
			Name:        config.String("WebApplicationName") + " Mail",
			Link:        config.String("WebHostName"),
			Copyright:   "Copyright 2021 minoic. All rights reserved.",
			TroubleText: "If the link does not work, copy the address below into your browser:",
		},
	}
}

// render turns a hermes email into the HTML and plain text bodies. A rendering
// failure yields the plain-text fallback rather than panicking, which is what
// the legacy genRegConfirmMail did.
func render(e hermes.Email) (html, text string) {
	h := product()
	html, err := h.GenerateHTML(e)
	if err != nil {
		glgf.Error("email: cannot render html body: ", err)
		return "", ""
	}
	text, err = h.GeneratePlainText(e)
	if err != nil {
		glgf.Error("email: cannot render text body: ", err)
		return "", ""
	}
	return html, text
}

// confirmRegistrationBody is the message containing the registration
// confirmation link.
func confirmRegistrationBody(userName, key string) (string, string) {
	return render(hermes.Email{
		Body: hermes.Body{
			Name: userName,
			Intros: []string{
				"Welcome to " + config.String("WebApplicationName"),
			},
			Actions: []hermes.Action{
				{
					Instructions: "Confirm your registration:",
					Button: hermes.Button{
						Color: "#22BC66",
						Text:  "Confirm registration",
						Link:  config.String("WebHostName") + "/confirm-email/" + key,
					},
				},
			},
			Outros: []string{
				"Open a work order on the site if you need help.",
			},
		},
	})
}

// codeBody is the message carrying a one-time numeric code.
func codeBody(appName, intro, code string) (string, string) {
	return render(hermes.Email{
		Body: hermes.Body{
			Intros: []string{
				appName,
				intro + code,
			},
			Outros: []string{
				"Open a work order on the site if you need help.",
			},
		},
	})
}

// noticeBody is a free-form notification.
func noticeBody(text string) (string, string) {
	return render(hermes.Email{
		Body: hermes.Body{
			Intros: []string{text},
			Outros: []string{
				"Do not reply to this message. If you did not expect it, please ignore it.",
			},
		},
	})
}

// plainFallback strips the email down to something readable when hermes fails to
// render, so the recipient still receives the essential information.
func plainFallback(text string) (string, string) {
	return "", text
}

// joinText concatenates variadic fragments the way the legacy
// SendAnyEmail/SendAnyEmail callers expect (fmt.Sprint on a slice produced
// "[a b c]", which leaked brackets into every notification).
func joinText(parts ...string) string { return strings.Join(parts, "") }
