//
//  ViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 4.05.2024.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var context: NSManagedObjectContext?
    let model = JSONViewModel()
    let data = DataLoader().medicData
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].medicineName
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
   
        if model.medicine.isEmpty {
            let appdel = UIApplication.shared.delegate as! AppDelegate
            context = appdel.persistentContainer.viewContext
            
            model.getData(context: context ?? NSManagedObjectContext())
            model.fetchData(context: context ?? NSManagedObjectContext())
        }
        
   

        // Do any additional setup after loading the view.
    
         
    }


}

