//
//  EditReminderViewModel.swift
//  Medicine Reminder
//
//  Created by Omer on 30.05.2024.
//

import Foundation


final class EditReminderViewModel {
    private var days = [Int]()
    private var hours = [Date]()
    
    
    func setDate(days: [Int], hours: [Date]) {
        self.days = days
        self.hours = hours
    }
    
}


