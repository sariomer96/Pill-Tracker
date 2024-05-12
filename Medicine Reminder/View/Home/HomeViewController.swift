//
//  HomeViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 9.05.2024.
//

import UIKit
import CoreData

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchReminders()
    }
    func fetchReminders() -> [Reminder] {
        var reminders = [Reminder]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return reminders }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            reminders = try context.fetch(fetchRequest)
            for i in reminders {
                print("\(i.name!)---- \(i.days!) -----   \(i.hours!)")
            }
        } catch {
            print("Error fetching reminders: \(error.localizedDescription)")
        }
        
        return reminders
    }
    
}
