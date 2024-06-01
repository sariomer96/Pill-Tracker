//
//  SelectedDaysViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation

class SelectedDaysViewModel: ReminderData {
   // static let shared = SelectedDaysViewModel()
    var reminder: Reminder?
    let maxTimeCountLimit = 10 //
    var callBackMaxLimit:CallBack<Int>?
    var callBackAddTime:CallBack<Int>?
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
        print("reminder geldi  \(reminder.id) \(reminder.hours as! [Date]) \(reminder.days))")
       // print("set rem \(self.reminder?.name) \(self.reminder?.type) \(self.reminder?.endDate)")
    }
   
    
    func CheckMaxTimeCount(rowCount: Int, row: Int) {
        if maxTimeCountLimit + 1 == rowCount {
            callBackMaxLimit?(row)
        } else {
     
            callBackAddTime?(row)
        } 
    }
    
    func setReminder(days: [Int], hours: [Date]) {
        self.reminder?.days = days as NSObject
        self.reminder?.hours = hours as NSObject
       
    }

    
}
