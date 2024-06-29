
import Foundation
import CoreData

typealias VoidCallBack = (() -> Void)
typealias CallBack<T> = ((T) -> Void)

class MedicineListManager: ObservableObject {
    
    
      var callBackSearch: CallBack<[MedicineTables]>?
    var searchList = [MedicineTables]()
    @Published var medicine : [MedicineDataModel] = []
    @Published var medicineCore: [MedicineTables] = []
 
    let medicDb = "medicDB"
    let medicineTables = "MedicineTables"
    let fetchRequest: NSFetchRequest<MedicineTables> = NSFetchRequest<MedicineTables>(entityName: "MedicineTables")
    func saveData(context: NSManagedObjectContext) {
        for i in medicine {
            let entity = MedicineTables(context: context)
            entity.id = Int16(i.id ?? 0)
            entity.medicineName = i.medicineName
            _ = UUID()
        }
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
   
    func searchMedicineName(searchText: String, context: NSManagedObjectContext)   {
        let predicate = NSPredicate(format: "medicineName CONTAINS[cd] %@", searchText)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let medTable = results as? [MedicineTables] else { return }
            searchList = medTable
            callBackSearch?(medTable)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    func getData(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void)  {
        let fetchReques: NSFetchRequest<MedicineTables> = NSFetchRequest<MedicineTables>(entityName: medicineTables)

              do {
                  let results = try context.fetch(fetchReques)
                  
                  medicineCore = results
                
                  completion(medicineCore.isEmpty)
                   
              } catch {
                  fatalError(error.localizedDescription)
              }
    }
    func fetchData(context: NSManagedObjectContext) {
        if let location = Bundle.main.url(forResource: medicDb, withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                let decoder = JSONDecoder()
                let dataFromJson = try decoder.decode([MedicineDataModel].self, from: data)
                self.medicine = dataFromJson
                self.saveData(context: context)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
