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
    var reminderModel: ReminderModel?
    let maxTimeCountLimit = 10 //
    var callBackMaxLimit:CallBack<IndexPath>?
    var callBackAddTime:CallBack<IndexPath>?
    func getReminder(reminder: ReminderModel) {
       // self.reminder = reminder
    
        self.reminderModel = reminder
         
        print("getreminderrrrr")
        
    }
   
    
    func CheckMaxTimeCount(rowCount: Int, indexPath: IndexPath) {
        if maxTimeCountLimit + 1 == rowCount {
            callBackMaxLimit?(indexPath)
        } else {
     
            callBackAddTime?(indexPath)
        }
    }
    
    func setReminder(days: [Int], hours: [Date]) {
//        self.reminder?.days = days as NSObject
//        self.reminder?.hours = hours as NSObject
      
        self.reminderModel?.days = days
        self.reminderModel?.hours = hours
       
    }

   
     
    
}
