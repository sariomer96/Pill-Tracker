
import Foundation
import UIKit

private let storyboardName = "Main"

 class BaseViewController: UIViewController {
     
   let selectedDaysViewController = "SelectedDaysViewController"
   let reminderConfigViewController = "ReminderConfigViewController"
   let medicineViewController = "MedicineViewController"
   let editReminderViewController = "EditReminderViewController"
     
     func pushViewController<T: UIViewController>(param: T.Type, vcIdentifier: String ) {
         let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
         guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? T else {
             fatalError("\(FatalError.failedIdentifier.rawValue) \(T.self)")
         }
         self.navigationController!.pushViewController(vc, animated: true)
     }
     
     func getViewController<T: UIViewController>(param: T.Type, vcIdentifier: String ) -> UIViewController {
         let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
         guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? T else {
             fatalError("\(FatalError.failedIdentifier.rawValue) \(T.self)")
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


enum FatalError: String {
    case failedIdentifier = "View controller with identifier  is not of type"
    case failedInstantiate = "Failed to instantiate view controller from storyboard"
}
