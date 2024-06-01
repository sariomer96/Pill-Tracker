//
//  EditReminderViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 30.05.2024.
//

import Foundation


final class EditReminderViewModel: SelectedDaysViewModel  {
 
    override func setReminder(days: [Int], hours: [Date]) {
        self.reminder?.days = days as NSObject
        self.reminder?.hours = hours as NSObject
        print("set REMIONDER \(self.reminder?.hours as! [Date])")
    }
    
    
}


