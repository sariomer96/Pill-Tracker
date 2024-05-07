//
//  ViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 4.05.2024.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var context: NSManagedObjectContext?
    var isSearching = false
    
    let medicineViewModel = JSONViewModel()
    let data = DataLoader().medicData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return medicineViewModel.searchList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = medicineViewModel.searchList[indexPath.row].medicineName
        return cell
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
           
        
        
   

        // Do any additional setup after loading the view.
    
         
    }


}


extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
        medicineViewModel.searchMedicineName(searchText: searchText, context: context ?? NSManagedObjectContext())
         
        print("work")
               tableView.reloadData()
        
    }
    
}
