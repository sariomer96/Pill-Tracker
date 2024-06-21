//
//  EditReminderViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 30.05.2024.
//

import Foundation
 
    
 

final class EditReminderViewModel: SelectedDaysViewModel, ReminderGetData  {
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
    }
    
 
    override func setReminder(days: [Int], hours: [Date]) {
        print("set remind")
        self.reminderModel?.days = days
        self.reminderModel?.hours = hours
       self.reminder?.days = days as NSObject
      self.reminder?.hours = hours as NSObject
        print("remindFSKGFSGJer \(reminder?.id)")
 
    }
    
    
}


