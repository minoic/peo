package MinoMessage

import "git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"

func Send(message MinoDatabase.Message) error {
	DB := MinoDatabase.GetDatabase()
	if err := DB.Create(&message).Error; err != nil {
		return err
	}
	return nil
}

func UnReadNum(receiverID uint) int {

}
