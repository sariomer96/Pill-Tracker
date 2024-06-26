 
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
        
        addButton.addCorner(radiusRate: 25.0)
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
      
        reminderModel = ReminderModel()
  
        reminderModel?.id = UUID()
        reminderModel?.name = medicNameTF.text
        reminderModel?.type = medicTypesDropDownButton.currentTitle
        
        
        let vc =  getViewController(param: SelectedDaysViewController.self, vcIdentifier: selectedDaysViewController) as! SelectedDaysViewController
          sendReminderDelegate = vc.selectedDaysViewModel.self
      
        sendReminderDelegate?.getReminder(reminder: reminderModel!)
         pushViewController(vc: vc)
         
    }
     
    func showDropDown() {
        let  action = getDropDownActions() { _ in
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
