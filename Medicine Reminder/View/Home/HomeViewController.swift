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
     
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: "RemindersTableViewCell", bundle: nil), forCellReuseIdentifier: "RemindersTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getReminders()
        homeViewModel.checkForPermission()
  
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTableViewCell", for: indexPath) as! RemindersTableViewCell
        cell.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
//       
//        print(homeViewModel.countDownList.count)
           //  print("indexpathrow \(indexPath.row)  -----    \(homeViewModel.countDownList.count)")
            let countDown = homeViewModel.countDownList[indexPath.row]
        
        
        cell.configure(with: countDown, reminder: homeViewModel.reminders[indexPath.row])
        
        let hours = homeViewModel.reminders[indexPath.row].hours as? [Date]
        guard hours != nil else { return UITableViewCell() }
    

        
        return cell
    }
    
     
}
