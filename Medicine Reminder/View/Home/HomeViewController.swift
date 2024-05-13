//
//  HomeViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 9.05.2024.
//

import UIKit
import CoreData

class HomeViewController: BaseViewController {
    let homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getReminders()
    }
    
    func getViewContext() -> NSManagedObjectContext {
        let  appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let appDelegate = appDelegate else {  fatalError("AppDelegate is nil!") }
        let context = appDelegate.persistentContainer.viewContext
        return context
       
    }
    func getReminders() -> [Reminder] {
         let reminders = [Reminder]()
         let context = getViewContext()
         let reminderList = homeViewModel.fetchReminders(context: context, reminder: reminders)
        
        return reminderList
    }
    
}
