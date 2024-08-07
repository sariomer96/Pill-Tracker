
import UIKit
import CoreData
 
final class HomeViewController: BaseViewController {
    
    @IBOutlet weak var addMedicineButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let homeViewModel = HomeViewModel()
    var delegateReminder: ReminderGetData?
    var delegateReminderModel: ReminderData?
    
    let reminderTableViewCell = "RemindersTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.hidesBackButton = true
        
        addMedicineButton.addCorner(radiusRate: 25)
 
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = medicineViewController
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getReminders()
        self.tableView.register(UINib(nibName: reminderTableViewCell, bundle: nil), forCellReuseIdentifier: reminderTableViewCell)
        
        homeViewModel.checkForPermission()
        homeViewModel.configureCountDown { str in
      
            self.tableView.reloadData()
        }
        
         for (index, i) in homeViewModel.countDownList.enumerated() {
            i.callBack = { [weak self] str in
                guard let self = self else { return }
                
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
         let cell = tableView.dequeueReusableCell(withIdentifier: reminderTableViewCell, for: indexPath) as? RemindersTableViewCell
  
          cell?.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
     
          let countDown = homeViewModel.countDownList[indexPath.row]
        
        
          cell?.configure(with: countDown, reminder: homeViewModel.reminders[indexPath.row])
         
        return cell ?? RemindersTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = getViewController(param: EditReminderViewController.self, vcIdentifier: editReminderViewController)
        
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
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: ActionText.shared.delete) { (action, indexPath) in
            let alertController = UIAlertController(title: AlertText.shared.alertTitle, message: ActionText.shared.deleteAlert, preferredStyle: .alert)
                
            let confirmAction = UIAlertAction(title: ActionText.shared.delete, style: .destructive) { _ in
               
                    do {
                        try CoreDataManager.shared.removeData(context: self.getViewContext(), reminder: self.homeViewModel.reminders[indexPath.row])
                        self.homeViewModel.reminders.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                
            let cancelAction = UIAlertAction(title: ActionText.shared.cancel, style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                 
                self.present(alertController, animated: true, completion: nil)
            }
        return [deleteAction]
    }
}
