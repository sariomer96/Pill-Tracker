

import Foundation
import CoreData

class HomeViewModel {
    
    var reminders = [Reminder]()
    func fetchReminders(context: NSManagedObjectContext) {
       
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            reminders = try context.fetch(fetchRequest)
            for i in reminders {
                print("\(i.name)---- \(i.days) -----   START HOUR \(i.startHour)  ------    FREQ \(i.reminderFrequency)")
            }
        } catch {
            print("Error fetching reminders: \(error.localizedDescription)")
        }
        
      
    }
}
