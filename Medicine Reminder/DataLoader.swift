//
//  DataLoader.swift
//  Medicine Reminder
//
//  Created by Omer on 4.05.2024.
//

import Foundation

public class DataLoader {
    var medicData = [MedicineData]()
    
    init() {
        load() 
    }
   
    func load() {
        if let location = Bundle.main.url(forResource: "medicDB", withExtension: "json") {
            // do catch in case of an error
            do {
                let data = try Data(contentsOf: location)
                let decoder = JSONDecoder()
                let dataFromJson = try decoder.decode([MedicineData].self, from: data)
                self.medicData = dataFromJson
                print(medicData)
            } catch {
                print("error \(error)")
            }
        }
    }
}
