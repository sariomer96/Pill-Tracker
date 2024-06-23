
import Foundation

class SelectedDaysViewModel: ReminderData {
  
    
   
    
    var reminder: Reminder?
    var reminderModel: ReminderModel?
    let maxTimeCountLimit = 10 //
    var callBackMaxLimit:CallBack<IndexPath>?
    var callBackAddTime:CallBack<IndexPath>?

    func getReminder(reminder: ReminderModel) {
        self.reminderModel = reminder
    }

    func CheckMaxTimeCount(rowCount: Int, indexPath: IndexPath) {
        if maxTimeCountLimit + 1 == rowCount {
            callBackMaxLimit?(indexPath)
        } else {
     
            callBackAddTime?(indexPath)
        }
    }
    
    func setReminder(days: [Int], hours: [Date]) {
        self.reminderModel?.days = days
        self.reminderModel?.hours = hours
    }
}
