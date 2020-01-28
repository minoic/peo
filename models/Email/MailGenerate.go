package Email

import (
	"github.com/matcornic/v2"
)

func getProd() hermes.Hermes {
	return hermes.Hermes{
		Theme: new(hermes.Flat),
		Product: hermes.Product{
			Name:        "NTPE mail",
			Link:        "http://localhost",
			Logo:        "https://img.ntmc.tech/images/2019/12/28/NX8HnUQpzzonZ77u.png",
			Copyright:   "Copyright © 2020 Mino. All rights reserved.",
			TroubleText: "TroubleText?????",
		},
	}
}

func genRegConfirmMail(userName string) (string, string) {
	h := getProd()
	email := hermes.Email{
		Body: hermes.Body{
			Name: userName,
			Intros: []string{
				"Welcome to NTPE! ",
			},
			Actions: []hermes.Action{
				{
					Instructions: "click to confirm your register:",
					Button: hermes.Button{
						Color: "#22BC66",
						Text:  "Confirm your register",
						Link:  "",
					},
				},
			},
			Outros: []string{
				"Need help, or have questions? Just reply to this email, we'd love to help.",
			},
		}}
	mailBody, err := h.GenerateHTML(email)
	if err != nil {
		panic(err)
	}
	mailText, err := h.GeneratePlainText(email)
	if err != nil {
		panic(err)
	}
	return mailBody, mailText
}
