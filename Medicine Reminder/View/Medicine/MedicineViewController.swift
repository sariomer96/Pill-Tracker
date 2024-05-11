//
//  ViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 4.05.2024.
//

import UIKit
import CoreData
protocol ReminderConfigurable: AnyObject {
    func configure(with reminderText: String)
}

class MedicineViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var context: NSManagedObjectContext?
    var isSearching = false
    
    let medicineViewModel = JSONViewModel()
    let data = DataLoader().medicData
    
    var delegate:ReminderConfigurable?
 
     
    func sendDataToReminderConfig(str: String) {
         let medicineData = str // Bu veriyi gerçek veriyle değiştirin
        delegate?.configure(with: medicineData)
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return medicineViewModel.searchList.count
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        print("dfdf")
        pushViewController(param: ReminderConfigViewController.self, vcIdentifier: "ReminderConfigViewController")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
        cell.medicineLabel?.text = medicineViewModel.searchList[indexPath.row].medicineName
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectedMedicine = medicineViewModel.searchList[indexPath.row]
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ReminderConfigViewController") as? ReminderConfigViewController else {
          fatalError("aaa")
        }
        delegate = vc
        
      sendDataToReminderConfig(str: selectedMedicine.medicineName!)
        self.navigationController?.pushViewController(vc, animated: true)
        //pushViewController(param: reminder, vcIdentifier: "ReminderConfigViewController")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
         
            let appdel = UIApplication.shared.delegate as! AppDelegate
            context = appdel.persistentContainer.viewContext
            
            medicineViewModel.getData(context: context ?? NSManagedObjectContext()) {
                isEmpty in
                if isEmpty {
                    self.medicineViewModel.fetchData(context: self.context ?? NSManagedObjectContext())
               
                }
            }
        tableView.reloadData()
         
    }


}
extension MedicineViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
        medicineViewModel.searchMedicineName(searchText: searchText, context: context ?? NSManagedObjectContext())
          
               tableView.reloadData()
        
    }
    
}
