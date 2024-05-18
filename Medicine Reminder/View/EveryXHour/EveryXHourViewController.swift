//
//  EveryXHourViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import UIKit

class EveryXHourViewController: BaseViewController {

    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var timeFrequencyTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        let localDate = LocalTimeController.shared.getLocalTime(date: startTimePicker.date)
        let freq = Int(timeFrequencyTextField.text ?? "1")
    
        guard let freq = freq else { return }
        EveryXHourViewModel.shared.setReminder(timeFreq: freq, startTime: localDate)
        saveDB()
        pushViewController(param: HomeViewController.self, vcIdentifier: "HomeViewController")
    }
    
    func saveDB () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         let context = appDelegate.persistentContainer.viewContext
         CoreDataManager.shared.saveData(context: context)
    }
}
