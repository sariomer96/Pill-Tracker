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
        } catch {
            fatalError("Save failed")
        }
    }
    
    func removeData(context: NSManagedObjectContext, reminder:NSManagedObject) throws {
        do {
             context.delete(reminder)
             try context.save()
     
        } catch {
            fatalError("delete failed")
        }
    }
}
