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
    var delegateReminder: ReminderData?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: "RemindersTableViewCell", bundle: nil), forCellReuseIdentifier: "RemindersTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getReminders()
     
     //   homeViewModel.checkForPermission()
  
    }

    
    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getReminders()
 
        homeViewModel.checkForPermission()
        homeViewModel.configureCountDown { str in
            self.tableView.reloadData()
        }
        for (index, i) in homeViewModel.countDownList.enumerated() {
            i.callBack = { [weak self] str in
                guard let self = self else { return }
                print(str)
                let reminder = self.homeViewModel.reminders[index]
             
                let indexPathToRefresh = IndexPath(row: index, section: 0)

                self.homeViewModel.configureCountDownCell(reminder: reminder, countDownIndex: index) { str in
                    let indexPathToRefresh = IndexPath(row: index, section: 0)
                    self.refreshSpecificCell(at: indexPathToRefresh)
                }


            }
        }
       
    }
    func refreshSpecificCell(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func getViewContext() -> NSManagedObjectContext {
        let  appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let appDelegate = appDelegate else {  fatalError("AppDelegate is nil!") }
        let context = appDelegate.persistentContainer.viewContext
        return context
       
    }

    func getReminders() {
        
         let context = getViewContext()
          homeViewModel.fetchReminders(context: context)
         
    }
        
}
     
 
 


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return homeViewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if homeViewModel.countDownList.count == 0 || homeViewModel.reminders.count == 0 {
            return RemindersTableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTableViewCell", for: indexPath) as! RemindersTableViewCell
        cell.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
     
         let countDown = homeViewModel.countDownList[indexPath.row]
        
        
        cell.configure(with: countDown, reminder: homeViewModel.reminders[indexPath.row])
         
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = getViewController(param: EditReminderViewController.self, vcIdentifier: "EditReminderViewController")
        let edit = vc as! EditReminderViewController
        delegateReminder = edit.editReminderViewModel.self
        
        let reminder = homeViewModel.reminders[indexPath.row]
        delegateReminder?.getReminder(reminder: reminder)
     //   edit.editReminderViewModel.setDate(days: reminder.days as! [Int], hours: reminder.hours as! [Date])
        pushViewController(vc: edit)
    }
    
     
}
