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
  
        let localDate = getLocalTime(date: sender.date)
        date = localDate
        print(date)
    }
    
    func getLocalTime(date: Date) -> Date {
       let currentDate = date
       let localTimeZone = TimeZone.current
       let secondsFromGMT = localTimeZone.secondsFromGMT(for: currentDate)
       let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: currentDate)
        
        return localDate
    }
   
     
    
}
