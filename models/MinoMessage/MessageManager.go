package MinoMessage

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/jinzhu/gorm"
	"time"
)

func Send(senderName string, receiverID uint, text string) error {
	message := MinoDatabase.Message{
		Model:      gorm.Model{},
		SenderName: senderName,
		ReceiverID: receiverID,
		Text:       text,
		TimeText:   "",
		SendTime:   time.Now(),
	}
	DB := MinoDatabase.GetDatabase()
	if err := DB.Create(&message).Error; err != nil {
		return err
	}
	return nil
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
		messages[i].TimeText = m.SendTime.Format("2006-01-02 15:04:05")
		//eego.Debug(m.TimeText)
	}
	return messages
}

func ReadAll(receiverID uint) {
	DB := MinoDatabase.GetDatabase()
	DB.Model(&MinoDatabase.Message{}).Where("receiver_id = ?", receiverID).Update("have_read", true)
}
