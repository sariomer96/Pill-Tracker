//
//  UiTabBarController.swift
//  Medicine Reminder
//
//  Created by Omer on 20.06.2024.
//

import UIKit
import UIKit
protocol Refreshable {
    func refresh()
}
class UiTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab bar controller'ın delegate'ini kendiniz olarak ayarlayın
        self.delegate = self
    }
    
//    // UITabBarControllerDelegate metodu
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let navController = viewController as? UINavigationController,
//           let topViewController = navController.topViewController {
//            if let refreshableVC = topViewController as? Refreshable {
//                refreshableVC.refresh()
//            }
//        } else if let refreshableVC = viewController as? Refreshable {
//            refreshableVC.refresh()
//        }
//    }
}
