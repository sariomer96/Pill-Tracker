//
//  CoreDataManager.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation
import CoreData
class CoreDataManager {
    static let shared = CoreDataManager()
    
    
 
    func saveData(context: NSManagedObjectContext) {
         
        
        do {
            try context.save()
            print("success")
        } catch {
            fatalError("save failed")
        }
    }
    
    func removeData(context: NSManagedObjectContext, reminder: Reminder) throws {
        do {
        
            try context.delete(reminder)
        } catch {
            fatalError("save failed")
        }
    }
    
    func removeAllData(context: NSManagedObjectContext, reminder: [Reminder])  {
        do {
            for i in reminder {
                let delete: Void = try context.delete(i)
               
            }
  
        } catch {
            fatalError("save failed")
        }
    }
    
}
