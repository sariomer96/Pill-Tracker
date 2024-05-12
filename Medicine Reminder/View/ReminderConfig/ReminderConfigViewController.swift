//
//  ReminderConfigViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

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
    @IBOutlet weak var selectedDaysSwitch: UISwitch!
    @IBOutlet weak var medicTypesDropDownButton: UIButton!
     
 
    @IBOutlet weak var medicNameTF: UITextField!
    @IBOutlet weak var removeReminderSwitch: UISwitch!
    
    @IBOutlet weak var removeReminderDatePicker: UIDatePicker!
    @IBOutlet weak var everyXHoursSwitch: UISwitch!
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
   
    @IBAction func selectedDaysSwitchClicked(_ sender: UISwitch) {
        if sender.isOn == true {
            everyXHoursSwitch.isOn = false
        }
        
    }
    
    @IBAction func everyXHoursSwitchClicked(_ sender: UISwitch) {
        if sender.isOn == true {
            selectedDaysSwitch.isOn = false
            
        }
    }
    
    @IBAction func removeOnThisDaySwitchClicked(_ sender: UISwitch) {
        if sender.isOn == true {
            removeReminderDatePicker.isHidden = false
        } else {
            removeReminderDatePicker.isHidden = true
        }
    }
    
   
    @IBAction func nextClicked(_ sender: Any) {
        if selectedDaysSwitch.isOn == true || everyXHoursSwitch.isOn == true {
            guard let reminder = reminder else { return }
            reminder.name = medicNameTF.text
            reminder.type = medicTypesDropDownButton.currentTitle
            
            
           
            if removeReminderSwitch.isOn == true {
                reminder.endDate = removeReminderDatePicker.date
            }else {
                reminder.endDate = nil
            }
            
            
            if selectedDaysSwitch.isOn == true {
                sendReminderDelegate = SelectedDaysViewModel.shared.self
                sendReminderDelegate?.getReminder(reminder: reminder)
               
                pushViewController(param: SelectedDaysViewController.self, vcIdentifier: "SelectedDaysViewController")
            } else if everyXHoursSwitch.isOn == true {
                sendReminderDelegate = EveryXHourViewModel.shared.self
                sendReminderDelegate?.getReminder(reminder: reminder)
                pushViewController(param: EveryXHourViewController.self, vcIdentifier: "EveryXHourViewController")
            }
        } else {
            alert(title: "EKSIK", message: "BIRINI SEC!")
        }
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
