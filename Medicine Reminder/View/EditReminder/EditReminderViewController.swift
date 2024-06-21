//
//  EditReminderViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 29.05.2024.
//

import UIKit
protocol ReminderGetData {
    func getReminder(reminder: Reminder)
}

class EditReminderViewController: SelectedDaysViewController {
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    let editReminderViewModel = EditReminderViewModel()
    var isSaved = false
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineNameLabel.layer.masksToBounds = true
        medicineNameLabel.layer.cornerRadius = 15
        medicineNameLabel.layer.borderColor = UIColor.green.cgColor
        medicineNameLabel.layer.borderWidth = 1.0
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 25
        self.navigationController?.delegate = self
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("< Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        addTagToDayButtons()
        addTargetToDayButtons()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        
        editReminderViewModel.callBackMaxLimit = { [weak self] indexpath in
            guard let self = self else { return }
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            if indexpath.row == lastRowIndex-1{
                alert(title: "Max LIMIT", message: "MAX SAYIYA ULASTIN")
                
            }
        }
        
        editReminderViewModel.callBackAddTime = { [weak self] indexpath in
            guard let self = self else { return }
            addNewTime(tableView: tableView, indexPath: indexpath)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped() {
        
        if isSaved == false {
            // Uyarı oluştur
            let alertController = UIAlertController(title: "Uyarı", message: "Kaydedilmeyen veriler kaybolacak. Çıkmak istediğinizden emin misiniz ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "Evet", style: .default) { _ in
                // Evet butonuna basıldığında normal şekilde geri git
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            // Uyarıyı göster
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isSaved = false
        
        if let reminderDay = editReminderViewModel.reminderModel?.days, let reminderHour =
            editReminderViewModel.reminderModel?.hours{
            print("enable")
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
        print("hours \(hours.count) currentcount \(count)")
        self.count += hours.count
        
        for i in hours {
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
        isSaved = true
    }
}

extension EditReminderViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
       
        if indexPath.row == lastRowIndex-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTimeTableViewCell", for: indexPath) as? TimeTableViewCell ?? TimeTableViewCell()
           
            return cell
        } else {
            
            if lastRowIndex == 1 {
                return UITableViewCell()
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCell", for: indexPath) as? TimeTableViewCell
    
            guard let hoursArray = editReminderViewModel.reminderModel?.hours
            else { return TimeTableViewCell() }
            print("indpath \(indexPath.row)  count \(hoursArray.count)")
            
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

extension EditReminderViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count < (self.navigationController?.viewControllers.count ?? 0) {
            // Bu kontrol back butonuna basıldığını anlamamızı sağlar
            let alertController = UIAlertController(title: "Uyarı", message: "Bu ekrandan çıkmak istediğinizden emin misiniz?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hayır", style: .cancel) { _ in
                // İptal butonuna basıldığında herhangi bir işlem yapılmaz.
            }
            let confirmAction = UIAlertAction(title: "Evet", style: .default) { _ in
                // Evet butonuna basıldığında normal şekilde geri gidilir.
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            // Uyarıyı göster
            present(alertController, animated: true, completion: nil)
            
            // Back butonunun default davranışını engellemek için boş viewController döndür
            navigationController.viewControllers.insert(self, at: navigationController.viewControllers.count)
        }
    }


}


