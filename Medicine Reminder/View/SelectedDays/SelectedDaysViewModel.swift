//
//  SelectedDaysViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation

class SelectedDaysViewModel: ReminderData {
    static let shared = SelectedDaysViewModel()
    var reminder: Reminder?
    let maxTimeCountLimit = 10 //
    var callBackMaxLimit:CallBack<Int>?
    var callBackAddTime:CallBack<Int>?
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
       
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
        reminder?.days = days as NSObject
        reminder?.hours = hours as NSObject
        
    }

    
}
