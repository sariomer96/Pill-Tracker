//
//  EditReminderViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 29.05.2024.
//

import UIKit

class EditReminderViewController: SelectedDaysViewController {
 
    
    let editReminderViewModel = EditReminderViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        addTagToDayButtons()
        addTargetToDayButtons()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
         
         createTableCell()
        
        editReminderViewModel.callBackMaxLimit = { [weak self] max in
            guard let self = self else { return }
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            if max == lastRowIndex-1{
                alert(title: "Max LIMIT", message: "MAX SAYIYA ULASTIN")
                
            }
        }
        
        editReminderViewModel.callBackAddTime = { [weak self] row in
            guard let self = self else { return }
            addNewTime(tableView: tableView, indexPathRow: row)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let reminder = editReminderViewModel.reminder {
            setEnableDays(days: editReminderViewModel.reminder?.days as! [Int])
            setHourCount(hours: editReminderViewModel.reminder?.hours as! [Date])
        }
      
    }
    func setEnableDays(days: [Int]) {
        for day in days {
            for button in dayButtonList {
                if button.tag == day {
                    changeSelectedDayStatus(button: button)
                }
            }
        }
    }
    func setHourCount(hours: [Date]) {
        count += hours.count
       // tableView.reloadData()
    }
    
    func setHourDatePicker() {
        
    }
    override func saveButtonClicked(_ sender: Any) {
        days.sort()
        setReminder()
        saveDB()
        pushViewController(param: HomeViewController.self, vcIdentifier: "HomeViewController")
    }
    
    override func setReminder() {
        let hours = getHoursOfReminder()
         
        editReminderViewModel.setReminder(days: days, hours: hours)
    }
    override func saveDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         let context = appDelegate.persistentContainer.viewContext
        CoreDataManager.shared.saveData(context: context)
    }
    

}

extension EditReminderViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
       
        if indexPath.row == lastRowIndex-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTimeTableViewCell", for: indexPath) as! TimeTableViewCell
           
            return cell
        } else {
            
            if lastRowIndex == 1 {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCell", for: indexPath) as! TimeTableViewCell
    
            let hoursArray = editReminderViewModel.reminder?.hours as! [Date]
            if indexPath.row < hoursArray.count {
               
                cell.setDatePicker(date: hoursArray[indexPath.row])
            }
          
            tableViewCell[indexPath.row] = cell
             return tableViewCell[indexPath.row]
        }
    }
}
