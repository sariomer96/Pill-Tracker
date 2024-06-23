
import UIKit
import CoreData

protocol ReminderConfigurable: AnyObject {
    func configure(with reminderText: String)
}

class MedicineViewController: BaseViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var context: NSManagedObjectContext?
    
    
    let jSONModel = JSONMedicineModel()
    let data = DataLoader().medicData
    
    var delegate:ReminderConfigurable?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
          
         
    }
    override func viewWillAppear(_ animated: Bool) {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        context = appdel.persistentContainer.viewContext
        
        jSONModel.getData(context: context ?? NSManagedObjectContext()) {
            isEmpty in
            if isEmpty {
                self.jSONModel.fetchData(context: self.context ?? NSManagedObjectContext())
            }
        }
     tableView.reloadData()
  }
    
    func sendDataToReminderConfig(name: String) {
        delegate?.configure(with: name)
     }
    
    @IBAction func addMedicineClicked(_ sender: Any) {
        pushViewController(param: ReminderConfigViewController.self, vcIdentifier: "ReminderConfigViewController")
    }
}

extension MedicineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jSONModel.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        as! DataTableViewCell
        cell.medicineLabel?.text = jSONModel.searchList[indexPath.row].medicineName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectedMedicine = jSONModel.searchList[indexPath.row]
   
       let vc =  getViewController(param: ReminderConfigViewController.self, vcIdentifier: "ReminderConfigViewController")
        
        delegate = vc as? any ReminderConfigurable
        
      sendDataToReminderConfig(name: selectedMedicine.medicineName!)
        pushViewController(vc: vc)
    }
}
extension MedicineViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        jSONModel.searchMedicineName(searchText: searchText, context: context ?? NSManagedObjectContext())
          
               tableView.reloadData()
    }
}
