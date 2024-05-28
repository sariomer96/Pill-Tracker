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
    var count = 1
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
        for i in 1...11 {
            tableViewCell.append(TimeTableViewCell())
             
            
        }
    }
    
    func getHoursOfReminder() -> [Date]{
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        hours.removeAll()
        for i in 0...lastRowIndex-2 {
            if tableViewCell[i].isHidden == false {
               // print("say bakim \(i) ---   tableviewceldate  \(tableViewCell[i].date)")
                hours.append(tableViewCell[i].date)
                 
             }
             
           
        }
        return hours
   
    }
    func addTagToDayButtons() {
        sundayButton.tag = 1
        mondayButton.tag = 2
        tuesdayButton.tag = 3
        wednesdayButton.tag = 4
        thursdayButton.tag = 5
        fridayButton.tag = 6
        saturdayButton.tag = 7
        
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        days.sort()
        setReminder()
        saveDB()
        pushViewController(param: HomeViewController.self, vcIdentifier: "HomeViewController")
    }
    func setReminder() {
        let hours = getHoursOfReminder()
        
        print("OURSSSS \(hours)")
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
    }
    
    func addSelectedDays(tag: Int) {
        days.append(tag)
    }
    
    func removeDay(tag: Int) {
        days.removeAll { $0 == tag }
    }
    
    @objc func dayButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("pz butonuna tıklandı")
         
            changeSelectedDayStatus(button: sender)
            // Pazartesi butonuna özel işlemler burada yapılabilir
        case 2:
            print("Pazartesi butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 3:
            print("sali butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 4:
            print("car butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 5:
            print("per butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 6:
            print("cum butonuna tıklandı")
            changeSelectedDayStatus(button: sender)
        case 7:
            print("CT butonuna tıklandı")
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
            
            if lastRowIndex == 1 {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCell", for: indexPath) as! TimeTableViewCell
               
//            let localDate = LocalTimeController.shared.getLocalTime(date: Date())
//            cell.date = localDate
            print("SET VC")
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
