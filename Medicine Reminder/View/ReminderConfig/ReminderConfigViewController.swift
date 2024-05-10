//
//  ReminderConfigViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

import UIKit

class ReminderConfigViewController: BaseViewController {
    @IBOutlet weak var selectedDaysSwitch: UISwitch!
    
    @IBOutlet weak var everyXHoursSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func nextClicked(_ sender: Any) {
        let btn = sender as! UIButton

        btn.isSelected = !btn.isSelected
        changeBgColorNextButton(button: btn)
        print(btn.isSelected)
     //   btn.isHighlighted = !btn.isHighlighted
        if selectedDaysSwitch.isOn == false && everyXHoursSwitch.isOn == false {
            alert(title: "Kullanim ", message: "iki kullanimdan  birini sec")
           
            btn.isHighlighted = !btn.isHighlighted
        }
    }
    
    func changeBgColorNextButton(button: UIButton) {
        if button.isSelected == true {
      
        
        } else {
            button.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.4)
            button.backgroundColor = nil
        }
    }
}
