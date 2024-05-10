//
//  SelectedDaysViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

import UIKit

class SelectedDaysViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    var count = 2
    var tableCell = [TimeTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addTagToDayButtons()
        addTargetToDayButtons()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
   
        
    }
    func addTagToDayButtons() {
        mondayButton.tag = 0
        tuesdayButton.tag = 1
        wednesdayButton.tag = 2
        thursdayButton.tag = 3
        fridayButton.tag = 4
        saturdayButton.tag = 5
        sundayButton.tag = 6
    }

    func addTargetToDayButtons() {
        mondayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        tuesdayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        wednesdayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        thursdayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)

        fridayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        saturdayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        sundayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)

    }
    func changeSelectedDayStatus(button: UIButton) {
         
        button.isSelected = !button.isSelected
        if button.isSelected == true {
            button.backgroundColor = .green
            print("secili")
        
        } else {
            print("else")
            button.backgroundColor = nil
        }
    }
    
    @objc func dayButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Pazartesi butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
            // Pazartesi butonuna özel işlemler burada yapılabilir
        case 1:
            print("Salı butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 2:
            print("car butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 3:
            print("per butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 4:
            print("cum butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 5:
            print("ct butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 6:
            print("pz butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
            // Salı butonuna özel işlemler burada yapılabilir
        default:
            break
        }
    }

}

extension SelectedDaysViewController: UITableViewDelegate, UITableViewDataSource {
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
       
        if indexPath.row == lastRowIndex-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTimeTableViewCell", for: indexPath) as! TimeTableViewCell
        
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCell", for: indexPath) as! TimeTableViewCell
              print(count)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         addNewTime(tableView: tableView, indexPath: indexPath)
    }
    
    func addNewTime(tableView: UITableView, indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)

        if (indexPath.row == lastRowIndex - 1) {
          
            count += 1
            tableView.reloadData()
        }
    }
    
    
    
}
