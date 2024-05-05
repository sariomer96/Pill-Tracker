//
//  JSONViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 5.05.2024.
//

import Foundation
import CoreData

class JSONViewModel: ObservableObject {
    @Published var medicine : [MedicineJSON] = []
    @Published var medicineCore: [MedicineTables] = []
 
    func saveData(context: NSManagedObjectContext) {
        for i in medicine {
            let entity = MedicineTables(context: context)
            entity.id = i.id ?? 0
            entity.medicineName = i.medicineName
        }
        
        do {
            try context.save()
            print("success")
        } catch {
            
        }
    }
   
    func getData(context: NSManagedObjectContext)  {
        let fetchRequest: NSFetchRequest<MedicineTables> = NSFetchRequest<MedicineTables>(entityName: "MedicineTables")
 // EntityType, oluşturduğunuz NSManagedObject alt sınıfının adı olmalıdır.
              do {
                  let results = try context.fetch(fetchRequest)
                  
                   
                  medicineCore = results
                  print(medicineCore.count)
              } catch {
                  print("Veri çekme hatası: \(error.localizedDescription)")
                  
              }
       
    }
    func fetchData(context: NSManagedObjectContext) {
        if let location = Bundle.main.url(forResource: "medicDB", withExtension: "json") {
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: location)
                let decoder = JSONDecoder()
                let dataFromJson = try decoder.decode([MedicineJSON].self, from: data)
                self.medicine = dataFromJson
                self.saveData(context: context)
               
            } catch {
                print("error \(error)")
            }
        }
    }
}
