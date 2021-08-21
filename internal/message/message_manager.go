package message

import (
	"fmt"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/database"
)

var adminID uint

func init() {
	var user database.User
	database.GetDatabase().First(&user, "is_admin")
	adminID = user.ID
}

func Send(senderName string, receiverID uint, text ...interface{}) {
	message := database.Message{
		SenderName: senderName,
		ReceiverID: receiverID,
		Text:       fmt.Sprint(text...),
		TimeText:   "",
	}
	if err := database.GetDatabase().Create(&message).Error; err != nil {
		glgf.Error(err)
	}
}

func SendAdmin(text ...interface{}) {
	if adminID == 0 {
		return
	}
	message := database.Message{
		SenderName: "SYSTEM",
		ReceiverID: adminID,
		Text:       fmt.Sprint(text...),
		TimeText:   "",
	}
	if err := database.GetDatabase().Create(&message).Error; err != nil {
		glgf.Error(err)
	}
}

func UnReadNum(receiverID uint) int {
	DB := database.GetDatabase()
	var messages []database.Message
	DB.Where("receiver_id = ?", receiverID).Not("have_read = ?", true).Find(&messages)
	return len(messages)
}

func GetMessages(receiverID uint) []database.Message {
	DB := database.GetDatabase()
	var messages []database.Message
	DB.Where("receiver_id = ?", receiverID).Find(&messages)
	for i, m := range messages {
		messages[i].TimeText = m.CreatedAt.Format("2006-01-02 15:04:05")
		// glgf.Debug(m.TimeText)
	}
	for i, j := 0, len(messages)-1; i < j; i, j = i+1, j-1 {
		messages[i], messages[j] = messages[j], messages[i]
	}
	return messages
}

func ReadAll(receiverID uint) {
	DB := database.GetDatabase()
	DB.Model(&database.Message{}).Where("receiver_id = ?", receiverID).Update("have_read", true)
}
