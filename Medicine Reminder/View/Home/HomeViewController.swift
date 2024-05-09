//
//  HomeViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 9.05.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
}
