

import Foundation
import CoreData

class HomeViewModel {
    
    func fetchReminders(context: NSManagedObjectContext, reminder: [Reminder]) -> [Reminder] {
       // var reminders = [Reminder]()
        
        var r = reminder

        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            r = try context.fetch(fetchRequest)
            for i in r {
                print("\(i.name!)---- \(i.days!) -----   \(i.hours!)")
            }
        } catch {
            print("Error fetching reminders: \(error.localizedDescription)")
        }
        
        return r
    }
}
