//
//  ReminderConfigViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

import UIKit


class ReminderConfigViewController: BaseViewController, ReminderConfigurable {
    
    var medicName = ""
    func configure(with reminderText: String) {
        medicName = reminderText
        print("fgd")
    }
    
    
    
    
    @IBOutlet weak var selectedDaysSwitch: UISwitch!
    @IBOutlet weak var medicTypesDropDownButton: UIButton!
     
 
    @IBOutlet weak var medicNameTF: UITextField!
    
    @IBOutlet weak var removeReminderDatePicker: UIDatePicker!
    @IBOutlet weak var everyXHoursSwitch: UISwitch!
    let reminderConfigViewModel = ReminderConfig()
    override func viewDidLoad() {
        super.viewDidLoad()
        showDropDown()
        print("\(medicNameTF.text) aaaa")
        // Do any additional setup after loading the view.
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
