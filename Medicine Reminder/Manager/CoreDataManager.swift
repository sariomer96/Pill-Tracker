//

import Foundation
import CoreData
class CoreDataManager {
    static let shared = CoreDataManager()
     
    func saveData(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            fatalError(CoreDataError.saveFailed.rawValue)
        }
    }
    
    func removeData(context: NSManagedObjectContext, reminder:NSManagedObject) throws {
        do {
             context.delete(reminder)
             try context.save()
     
        } catch {
            fatalError(CoreDataError.deleteFailed.rawValue)
        }
    }
}

enum CoreDataError: String {
    case saveFailed = "Save failed"
    case deleteFailed = "Delete failed"
}
