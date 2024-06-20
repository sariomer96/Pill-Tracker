//
//  BaseViewController.swift
//  quiz
//
//  Created by Omer on 5.01.2024.
//

import Foundation
import UIKit
 class BaseViewController: UIViewController {
     func pushViewController<T: UIViewController>(param: T.Type, vcIdentifier: String ) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? T else {
             fatalError("View controller with identifier  is not of type \(T.self)")
         }
   
         
         self.navigationController!.pushViewController(vc, animated: true)
     }
     
     func getViewController<T: UIViewController>(param: T.Type, vcIdentifier: String ) -> UIViewController {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? T else {
             fatalError("View controller with identifier  is not of type \(T.self)")
         }
         return vc
     }
     
     func pushViewController(vc: UIViewController) {
         self.navigationController!.pushViewController(vc, animated: true)
     }

    func refresh() {}

    func alert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okey = UIAlertAction(title: "OK", style: .default) { _ in
            self.refresh()
        }

        alert.addAction(okey)

        self.present(alert, animated: true)

    }
    func alert(title: String, message: String, completion: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okey = UIAlertAction(title: "OK", style: .default) { _ in

            completion(true)
        }
        alert.addAction(okey)
        self.present(alert, animated: true)
    }
}

extension UIViewController {

    // MARK: - Methods
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return self.instantiateFromStoryboardHelper(name)
    }

    private class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self))
                    as? T else {
                fatalError("Failed to instantiate view controller from storyboard")
            }
            return controller
    }
}
