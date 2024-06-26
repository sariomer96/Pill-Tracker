
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
    
    var dayButtonList = [UIButton]()
    var datePickerCount = 1
    var tableCell = [TimeTableViewCell]()
    var tableViewCell = [TimeTableViewCell]()
    let addTimeTableViewCell = "addTimeTableViewCell"
    let timeTableViewCell = "timeTableViewCell"
    let selectedDaysViewModel = SelectedDaysViewModel()
    let homeViewController = "HomeViewController"
    let green = "#5DB075"
    var days = [Int]()
    var hours = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.hidesBackButton = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        addTagToDayButtons()
        addTargetToDayButtons()
        addButtonList()
         
        
        selectedDaysViewModel.callBackMaxLimit = { [weak self] indexpath in
            guard let self = self else { return }
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            if indexpath.row == lastRowIndex-1{
                alert(title: AlertText.shared.alertTitle, message: AlertText.shared.alertMaxMessage)
                
            }
        }
        
        selectedDaysViewModel.callBackAddTime = { [weak self] indexpath in
            guard let self = self else { return }
            addNewTime(tableView: tableView, indexPath: indexpath)
        }
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func saveDB () {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         let context = appDelegate.persistentContainer.viewContext
   
      let newReminder = Reminder(context: context)
          newReminder.startDate = Date()
          newReminder.id = selectedDaysViewModel.reminderModel?.id
          newReminder.name = selectedDaysViewModel.reminderModel?.name
          newReminder.type = selectedDaysViewModel.reminderModel?.type
          newReminder.days = selectedDaysViewModel.reminderModel?.days as? NSObject
          newReminder.hours = selectedDaysViewModel.reminderModel?.hours  as? NSObject
        
         CoreDataManager.shared.saveData(context: context)
    }
    
    func getHoursOfReminder() -> [Date]{
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        hours.removeAll()
        for i in 0...lastRowIndex-2 {
            if tableViewCell.count > i && tableViewCell[i].isHidden == false {
                 
                if  let editDate =    Calendar.current.date(byAdding: .hour, value: 3, to: tableViewCell[i].date) {
                    hours.append(editDate)
                }
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
    
    func addButtonList() {
        dayButtonList.append(sundayButton)
        dayButtonList.append(mondayButton)
        dayButtonList.append(tuesdayButton)
        dayButtonList.append(wednesdayButton)
        dayButtonList.append(thursdayButton)
        dayButtonList.append(fridayButton)
        dayButtonList.append(saturdayButton)
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        days.sort()
        let lastRow = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        
        if lastRow > 1 &&  days.count > 0 {
            let hours = getHoursOfReminder()
            setReminder(hours: hours)
            saveDB()
            
            pushViewController(param: HomeViewController.self, vcIdentifier: homeViewController)
        } else {
            alert(title: AlertText.shared.alertTitle, message: TimerTextUtility.shared.timerAlert)
        }
    }
    
    func setReminder(hours: [Date]) {
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
             
            button.backgroundColor = UIColor(hexaString: self.green)
             
            addSelectedDays(tag: button.tag)
        
        } else {
            button.backgroundColor = .lightGray
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
            changeSelectedDayStatus(button: sender)

        case 2:
            changeSelectedDayStatus(button: sender)
        case 3:
            changeSelectedDayStatus(button: sender)
        case 4:
            changeSelectedDayStatus(button: sender)
        case 5:
            changeSelectedDayStatus(button: sender)
        case 6:
            changeSelectedDayStatus(button: sender)
        case 7:
            changeSelectedDayStatus(button: sender)
        default:
            break
        }
    }

}
extension SelectedDaysViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
       
        if indexPath.row == lastRowIndex-1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: addTimeTableViewCell, for: indexPath) as? TimeTableViewCell else { return TimeTableViewCell()}
            cell.tag = 1
            return cell
        } else {
            
            if lastRowIndex == 1 {
                return UITableViewCell()
            }
             return tableViewCell[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        
        selectedDaysViewModel.CheckMaxTimeCount(rowCount: lastRowIndex, indexPath: indexPath)
    } 
    
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
           if lastRowIndex - 1 == indexPath.row {
               return nil
           }
           let deleteAction = UITableViewRowAction(style: .destructive, title: ActionText.shared.delete) { (action, indexPath) in
             
               self.datePickerCount -= 1
               self.tableViewCell.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           return [deleteAction]
       }
    
    func addNewTime(tableView: UITableView, indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)

        if (indexPath.row == lastRowIndex - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: timeTableViewCell, for: indexPath) as! TimeTableViewCell
             
            tableViewCell.append(cell)
            datePickerCount += 1
            tableView.reloadData()
        }
    }
     
}

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}

