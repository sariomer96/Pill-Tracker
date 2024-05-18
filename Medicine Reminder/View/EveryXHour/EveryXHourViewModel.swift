//
//  EveryXHourViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation

class EveryXHourViewModel: ReminderData{
    var reminder: Reminder?
     static let shared = EveryXHourViewModel()
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
        print("worokrokwok \(self.reminder?.type) \(reminder.endDate)")
    }
     
    func setReminder(timeFreq: Int, startTime: Date) {
        let freq = Int16(timeFreq)
        reminder?.reminderFrequency = freq
        reminder?.startHour = startTime
    }
    
    
}
