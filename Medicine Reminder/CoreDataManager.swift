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
    
    
    func editReminderData(reminder: Reminder, context: NSManagedObjectContext) {
        // Bir fetch request oluşturuyoruz
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        
        // Güncellemek istediğimiz spesifik veriyi filtreliyoruz (Örneğin ID ile)
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(String(describing: reminder.id))")
        
        do {
            // Fetch request'i çalıştırıyoruz
            let result = try context.fetch(fetchRequest)
            
            // Sonuçlardan ilkini alıyoruz (varsayım olarak bir tane sonuç döneceğini düşünüyoruz)
            if let reminderToUpdate = result.first as? NSManagedObject {
            
          
                // Değişiklikleri kaydediyoruz
                try context.save()
                print("Reminder updated successfully")
            }
        } catch {
            print("Failed to fetch or update data: \(error.localizedDescription)")
        }
    }
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
    
}
