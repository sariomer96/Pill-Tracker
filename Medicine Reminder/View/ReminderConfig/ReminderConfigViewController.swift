 
import UIKit
import CoreData


protocol ReminderData {
   func getReminder(reminder: Reminder)
}
class ReminderConfigViewController: BaseViewController, ReminderConfigurable {
  
    var reminder:Reminder?
    var medicName = ""
    func configure(with reminderText: String) {
        medicName = reminderText
     
    }
    @IBOutlet weak var medicTypesDropDownButton: UIButton!
    @IBOutlet weak var medicNameTF: UITextField!
 
    
 
    let reminderConfigViewModel = ReminderConfig()
    var sendReminderDelegate:ReminderData?
    override func viewDidLoad() {
        super.viewDidLoad()
        showDropDown()
        let appdel = UIApplication.shared.delegate as! AppDelegate
        var context = appdel.persistentContainer.viewContext
      
        
        reminder = Reminder(context: context)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        medicNameTF.text = medicName
    }
    @IBAction func nextClicked(_ sender: Any) {
        guard let reminder = reminder else { return }
        reminder.id = UUID()
        reminder.name = medicNameTF.text
        reminder.type = medicTypesDropDownButton.currentTitle
        
        let vc =  getViewController(param: SelectedDaysViewController.self, vcIdentifier: "SelectedDaysViewController") as! SelectedDaysViewController
          sendReminderDelegate = vc.selectedDaysViewModel.self
          
          sendReminderDelegate?.getReminder(reminder: reminder)
         pushViewController(vc: vc)
         
    }
     
    func showDropDown() {
        let  action = getDropDownActions() { count in
          

        }
             medicTypesDropDownButton.menu = UIMenu(children: action)
             medicTypesDropDownButton.showsMenuAsPrimaryAction = true

    }
    var action = [UIAction]()
    func getDropDownActions(completion: @escaping (Int) -> Void) -> [UIAction] {
        
        let optionClosure = {(action: UIAction) in
             
        }
        for i in reminderConfigViewModel.medicTypes {
            action.append(UIAction(title: i, state: .on, handler: optionClosure))
        }
        
        return action
        
    }
}
