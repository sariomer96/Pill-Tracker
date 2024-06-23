
import UIKit

class TimeTableViewCell: UITableViewCell {
 
    @IBOutlet weak var datePicker: UIDatePicker!
  
    var date = Date()
  
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        date = sender.date
    }

    func setDatePicker(date: Date) {
 
        if let correctedDate = Calendar.current.date(byAdding: .hour, value: -3, to: date) {
             datePicker.date = correctedDate
             self.date = correctedDate
           }
    }
}
