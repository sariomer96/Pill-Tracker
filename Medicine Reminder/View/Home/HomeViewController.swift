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
    var countDownList = [CountDown]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: "RemindersTableViewCell", bundle: nil), forCellReuseIdentifier: "RemindersTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
 
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getReminders()
        tableView.reloadData()
        homeViewModel.checkForPermission()
        setCountDown()
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
    
    func setCountDown() {
        for reminder in homeViewModel.reminders {
           let hours = reminder.hours as? [Date]
            guard let hours = hours else { return }
            
            let localDate = homeViewModel.getLocalDate(date: Date())
          //MARK: FIND CLOSEST HOUR
         if let closestDate = homeViewModel.findClosestFutureHour(dates: hours, from: localDate) {
             
  
             let str = homeViewModel.convertHour(date: closestDate)
          //   cell.reminderDateLabel.text = "HATIRLATMA \(str)"
             //MARK: FIND DIFFERENCE
             
             let strCurr = homeViewModel.convertHour(date: localDate)
             let strClosest = homeViewModel.convertHour(date: closestDate)
         
             if let difference = homeViewModel.timeDifference(from: strCurr, to: strClosest) {
                 print("Fark: \(difference.hours) saat \(difference.minutes) dakika")
                 var countDown = CountDown(hours: difference.hours, minutes: difference.minutes)
                 countDownList.append(countDown)
                // cell.startCountdown(hours: difference.hours, minutes: difference.minutes)
             } else {
                 print("Geçersiz saat formatı")
             }
         } else {
             print("Gelecek saat bulunamadı.")
         }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTableViewCell", for: indexPath) as! RemindersTableViewCell
        cell.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
        let countDown = countDownList[indexPath.row]
        cell.configure(with: countDown)
        
        let hours = homeViewModel.reminders[indexPath.row].hours as? [Date]
        guard let hours = hours else { return UITableViewCell() }
     
//           let localDate = homeViewModel.getLocalDate(date: Date())
//         //MARK: FIND CLOSEST HOUR
//        if let closestDate = homeViewModel.findClosestFutureHour(dates: hours, from: localDate) {
//            
// 
//            let str = homeViewModel.convertHour(date: closestDate)
//            cell.reminderDateLabel.text = "HATIRLATMA \(str)"
//            //MARK: FIND DIFFERENCE
//            
//            let strCurr = homeViewModel.convertHour(date: localDate)
//            let strClosest = homeViewModel.convertHour(date: closestDate)
//        
//            if let difference = homeViewModel.timeDifference(from: strCurr, to: strClosest) {
//                print("Fark: \(difference.hours) saat \(difference.minutes) dakika")
//               // cell.startCountdown(hours: difference.hours, minutes: difference.minutes)
//            } else {
//                print("Geçersiz saat formatı")
//            }
//        } else {
//            print("Gelecek saat bulunamadı.")
//        }
        
        return cell
    }
    
     
}
