//
//  HomeViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 9.05.2024.
//

import UIKit
import CoreData
 

class HomeViewController: BaseViewController {
    @IBOutlet weak var addMedicineButton: UIButton!
    let homeViewModel = HomeViewModel()
    var delegateReminder: ReminderGetData?
    var delegateReminderModel: ReminderData?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.hidesBackButton = true
        //navigationController?.navigationBar.isHidden = true
        addMedicineButton.layer.cornerRadius = 25
        addMedicineButton.layer.masksToBounds = true
      
        self.tableView.delegate = self
        self.tableView.dataSource = self
   
        
    }
   
    
    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appearrr")
        getReminders() 
        self.tableView.register(UINib(nibName: "RemindersTableViewCell", bundle: nil), forCellReuseIdentifier: "RemindersTableViewCell")
       
        print("calistiffg")
        homeViewModel.checkForPermission()
        homeViewModel.configureCountDown { str in
      
            self.tableView.reloadData()
        }
        print("homeViewModel \(homeViewModel.reminders.count)")
        for (index, i) in homeViewModel.countDownList.enumerated() {
            i.callBack = { [weak self] str in
                guard let self = self else { return }
                print("rem \(homeViewModel.reminders.count)  \(index)")
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTableViewCell", for: indexPath) as? RemindersTableViewCell
  
        cell?.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
     
          let countDown = homeViewModel.countDownList[indexPath.row]
        
        
        cell?.configure(with: countDown, reminder: homeViewModel.reminders[indexPath.row])
         
        return cell ?? RemindersTableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = getViewController(param: EditReminderViewController.self, vcIdentifier: "EditReminderViewController")
        let edit = vc as! EditReminderViewController
        delegateReminder = edit.editReminderViewModel.self
        delegateReminderModel = edit.editReminderViewModel.self
        let reminder = homeViewModel.reminders[indexPath.row]
         
        let rModel = ReminderModel()
        rModel.id = reminder.id
        rModel.name = reminder.name
        rModel.type = reminder.type
        rModel.days = reminder.days as? [Int]
        rModel.hours = reminder.hours as? [Date]
        
        delegateReminder?.getReminder(reminder: reminder)
        delegateReminderModel?.getReminder(reminder: rModel)
        pushViewController(vc: edit)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "KALDIR") { (action, indexPath) in
                // Show confirmation alert
                let alertController = UIAlertController(title: "UYARI", message: "Hatirlaticiyi kaldirmak istediginizden emin misiniz?", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                    // Veriyi diziden kaldır
                    do {
                        try CoreDataManager.shared.removeData(context: self.getViewContext(), reminder: self.homeViewModel.reminders[indexPath.row])
                        self.homeViewModel.reminders.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                    } catch {
                        fatalError("Error")
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Iptal", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                // Present the alert controller
                self.present(alertController, animated: true, completion: nil)
            }
        return [deleteAction]
    }
     
}


 

extension HomeViewController: UITabBarControllerDelegate {

  
    
    // UITabBarControllerDelegate metodu
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("clickk")
    }
    
    // Tıklanan tab için bir fonksiyon
    func tabSelected(at index: Int) {
        switch index {
        case 0:
            print("First tab selected")
            // İlk tab seçildiğinde yapılacak işlemler
        case 1:
            print("Second tab selected")
            // İkinci tab seçildiğinde yapılacak işlemler
        // Diğer tab'lar için ek case'ler ekleyebilirsiniz
        default:
            break
        }
    }
}
