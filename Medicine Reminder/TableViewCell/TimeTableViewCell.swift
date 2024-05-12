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
        // Initialization code
        
        
        // DatePicker'ın değeri değiştiğinde datePickerChanged metodu çağrılacak
       // datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
 
    }
  
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
 
        let currentDate = sender.date
             
         
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: currentDate)
        let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: currentDate)
        date = localDate
        print(date)
    }
    @IBAction func testClick(_ sender: Any) {
        print("click")
    }
    @IBAction func datePickerClicked(_ sender: Any) {
        print("tiklandi")
    }
    
     
    
}
