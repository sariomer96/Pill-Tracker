
import Foundation
  
final class EditReminderViewModel: SelectedDaysViewModel, ReminderGetData  {
    var isSaved = false
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
    }
    
 
    override func setReminder(days: [Int], hours: [Date]) {
// 
        self.reminderModel?.days = days
        self.reminderModel?.hours = hours
       self.reminder?.days = days as NSObject
      self.reminder?.hours = hours as NSObject
       
 
    }
    
    
}


