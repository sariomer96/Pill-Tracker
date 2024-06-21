 
import UIKit
import CoreData


protocol ReminderData {
   func getReminder(reminder: ReminderModel)
   
}
class ReminderConfigViewController: BaseViewController, ReminderConfigurable {
  
    var reminder: Reminder?
    var reminderModel: ReminderModel?
    var medicName = ""
    func configure(with reminderText: String) {
        medicName = reminderText
     
    }
    @IBOutlet weak var medicTypesDropDownButton: UIButton!
    @IBOutlet weak var medicNameTF: UITextField!
 
    
    @IBOutlet weak var addButton: UIButton!
    
    let reminderConfigViewModel = ReminderConfig()
    var sendReminderDelegate:ReminderData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 25.0
        addButton.layer.masksToBounds = true
        showDropDown()
   

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    override func viewWillAppear(_ animated: Bool) {
     
        medicNameTF.text = medicName
    }
    @IBAction func nextClicked(_ sender: Any) {
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        var context = appdel.persistentContainer.viewContext
     
//           reminder = Reminder(context: context)
//    //    guard let reminder = reminder else { return }
//        print("workk")
//        reminder?.id = UUID()
//        reminder?.name = medicNameTF.text
//        reminder?.type = medicTypesDropDownButton.currentTitle
          
        reminderModel = ReminderModel()
 //    guard let reminder = reminder else { return }
     print("workk")
        reminderModel?.id = UUID()
        reminderModel?.name = medicNameTF.text
        reminderModel?.type = medicTypesDropDownButton.currentTitle
        
        
        let vc =  getViewController(param: SelectedDaysViewController.self, vcIdentifier: "SelectedDaysViewController") as! SelectedDaysViewController
          sendReminderDelegate = vc.selectedDaysViewModel.self
       print("remiond er \(reminder)")
        sendReminderDelegate?.getReminder(reminder: reminderModel!)
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

extension ReminderConfigViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
}
