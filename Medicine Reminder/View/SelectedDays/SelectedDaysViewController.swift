//
//  SelectedDaysViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

import UIKit

class SelectedDaysViewController: BaseViewController {

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
    var tableViewCell = [TimeTableViewCell]()
    var days = [Int]()
    var hours = [Date]()
    let selectedDaysViewModel = SelectedDaysViewModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        addTagToDayButtons()
        addTargetToDayButtons()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
         
         createTableCell()
        
        selectedDaysViewModel.callBackMaxLimit = { [weak self] max in
            guard let self = self else { return }
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            if max == lastRowIndex-1{
                alert(title: "Max LIMIT", message: "MAX SAYIYA ULASTIN")
                
            }
        }
        
        selectedDaysViewModel.callBackAddTime = { [weak self] row in
            guard let self = self else { return }
            addNewTime(tableView: tableView, indexPathRow: row)
        }
        
        
    }
    
    func saveDB () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         let context = appDelegate.persistentContainer.viewContext
        CoreDataManager.shared.saveData(context: context)
    }
    func createTableCell() {
        for _ in 1...11 {
            tableViewCell.append(TimeTableViewCell())
        }
    }
    
    func getHoursOfReminder() -> [Date]{
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        hours.removeAll()
        for i in 0...lastRowIndex-2 {
            if tableViewCell[i].isHidden == false {
               // print(tableViewCell[i].date)
                hours.append(tableViewCell[i].date)
                 
             }
             
           
        }
        return hours
   
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

    @IBAction func saveButtonClicked(_ sender: Any) {
        days.sort()
        setReminder()
        saveDB()
    }
    func setReminder() {
        let hours = getHoursOfReminder()
        
        selectedDaysViewModel.setReminder(days: days, hours: hours)
        
         
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
            addSelectedDays(tag: button.tag)
        
        } else {
            print("else")
            button.backgroundColor = nil
            removeDay(tag: button.tag)
        }
         
       // print(days)
    }
    func addSelectedDays(tag: Int) {
        days.append(tag)
    }
    func removeDay(tag: Int) {
        days.removeAll { $0 == tag }
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
            //test.append(cell)
           
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCell", for: indexPath) as! TimeTableViewCell
              
   
            cell.datePicker.timeZone = TimeZone.current
          //  print(cell.datePicker.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short

            let formattedDate = dateFormatter.string(from: Date())

         //   print("Formatted date: \(formattedDate)")
            let currentDate = Date()

            let localTimeZone = TimeZone.current
            let secondsFromGMT = localTimeZone.secondsFromGMT(for: currentDate)
            let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: currentDate)

            print("Local Date: \(localDate)")
            print(localDate)
            cell.date = localDate
          //  print("selectedTime \(cell.datePicker.date)    -----    \(Date())")
            
            tableViewCell[indexPath.row] = cell
             return tableViewCell[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        
         
        selectedDaysViewModel.CheckMaxTimeCount(rowCount: lastRowIndex, row: indexPath.row)

       
    }
     
    func addNewTime(tableView: UITableView, indexPathRow: Int) {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)

        if (indexPathRow == lastRowIndex - 1) {
          
            count += 1
            tableView.reloadData()
        }
    }
    
    
    
}
