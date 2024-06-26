import UIKit

protocol ReminderGetData {
    func getReminder(reminder: Reminder)
}

class EditReminderViewController: SelectedDaysViewController {
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let editReminderViewModel = EditReminderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineNameLabel.addCorner(radiusRate: 15)
        medicineNameLabel.addBorder(borderWidth: 1.0,
                                    borderColor: UIColor.green.cgColor)
        
        saveButton.addCorner(radiusRate: 25)
         
        createBackButton()
        addTagToDayButtons()
        addTargetToDayButtons()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // self.navigationController?.delegate = self
        tableView.reloadData()
        
        editReminderViewModel.callBackMaxLimit = { [weak self] indexpath in
            guard let self = self else { return }
            let lastRowIndex = tableView.numberOfRows(inSection: 
                                                        tableView.numberOfSections-1)
            if indexpath.row == lastRowIndex-1{
                alert(title: AlertText.shared.alertTitle, message: AlertText.shared.alertMaxMessage)
            }
        }
        
        editReminderViewModel.callBackAddTime = { [weak self] indexpath in
            guard let self = self else { return }
            addNewTime(tableView: tableView, indexPath: indexpath)
        }
    }
    
    func createBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
    }
    
    @objc func backButtonTapped() {
        
        if editReminderViewModel.isSaved == false {
         
            let alertController = UIAlertController(title: AlertText.shared.alertTitle,
                                                    message:AlertText.shared.unsavedMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AlertText.shared.no,
                                             style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: AlertText.shared.yes, 
                                              style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
             
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editReminderViewModel.isSaved = false
        
        if let reminderDay = editReminderViewModel.reminderModel?.days, 
            let reminderHour =
            editReminderViewModel.reminderModel?.hours{
              
            setEnableDays(days: reminderDay )
            setHourCount(hours: reminderHour)
            medicineNameLabel.text = editReminderViewModel.reminder?.name
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
        datePickerCount += hours.count
        
        for _ in hours {
            tableViewCell.append(TimeTableViewCell())
        }
    }
    
    override func setReminder(hours: [Date]) {
        editReminderViewModel.setReminder(days: days, hours: hours)
    }
    
    override func saveDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        CoreDataManager.shared.saveData(context: context)
        editReminderViewModel.isSaved = true
    }
}

extension EditReminderViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
       
        if indexPath.row == lastRowIndex-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addTimeTableViewCell, for: indexPath) as? TimeTableViewCell ?? TimeTableViewCell()
           
            return cell
        } else {
            
            if lastRowIndex == 1 {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: timeTableViewCell, for: indexPath) as? TimeTableViewCell
    
            guard let hoursArray = editReminderViewModel.reminderModel?.hours
            else { return TimeTableViewCell() }
            
            if indexPath.row < hoursArray.count  {
                cell?.setDatePicker(date: hoursArray[indexPath.row])
            }
            tableViewCell[indexPath.row] = cell ?? TimeTableViewCell()
             return tableViewCell[indexPath.row]
        }
    }
    
    override   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
         
        editReminderViewModel.CheckMaxTimeCount(rowCount: lastRowIndex, indexPath: indexPath)
    }
}
