package MinoMessage

import (
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/jinzhu/gorm"
)

func Send(senderName string, receiverID uint, text string) {
	message := MinoDatabase.Message{
		Model:      gorm.Model{},
		SenderName: senderName,
		ReceiverID: receiverID,
		Text:       text,
		TimeText:   "",
	}
	DB := MinoDatabase.GetDatabase()
	if err := DB.Create(&message).Error; err != nil {
		panic(err)
	}
}

func UnReadNum(receiverID uint) int {
	DB := MinoDatabase.GetDatabase()
	var messages []MinoDatabase.Message
	DB.Where("receiver_id = ?", receiverID).Not("have_read = ?", true).Find(&messages)
	return len(messages)
}

func GetMessages(receiverID uint) []MinoDatabase.Message {
	DB := MinoDatabase.GetDatabase()
	var messages []MinoDatabase.Message
	DB.Where("receiver_id = ?", receiverID).Find(&messages)
	for i, m := range messages {
		messages[i].TimeText = m.CreatedAt.Format("2006-01-02 15:04:05")
		// beego.Debug(m.TimeText)
	}
	for i, j := 0, len(messages)-1; i < j; i, j = i+1, j-1 {
		messages[i], messages[j] = messages[j], messages[i]
	}
	return messages
}

func ReadAll(receiverID uint) {
	DB := MinoDatabase.GetDatabase()
	DB.Model(&MinoDatabase.Message{}).Where("receiver_id = ?", receiverID).Update("have_read", true)
}
