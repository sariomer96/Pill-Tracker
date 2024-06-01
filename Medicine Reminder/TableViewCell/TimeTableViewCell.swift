//
//  TimeTableViewCell.swift
//  Medicine Reminder
//
//  Created by Omer on 10.05.2024.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
  
    var date = Date()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
  
        let localDate = LocalTimeController.shared.getLocalTime(date: sender.date)
        date = localDate
        print("SET ")
    }
    
    deinit {
         print("REMOVED")
    }
   
    func setDatePicker(date: Date) {
       // datePicker.datePickerMode = .time
        if let correctedDate = Calendar.current.date(byAdding: .hour, value: -3, to: date) {
            datePicker.date = correctedDate
        }
    
    }
    
}
