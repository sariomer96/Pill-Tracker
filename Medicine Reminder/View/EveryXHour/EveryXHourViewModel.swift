//
//  EveryXHourViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 11.05.2024.
//

import Foundation

class EveryXHourViewModel: ReminderData{
    func getReminder(reminder: Reminder) {
        self.reminder = reminder
        print("worokrokwok \(self.reminder?.type) \(reminder.endDate)")
    }
    
    static let shared = EveryXHourViewModel()
    var reminder: Reminder?
    
}
