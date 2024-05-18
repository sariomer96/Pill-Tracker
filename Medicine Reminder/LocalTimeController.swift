//
//  LocalTimeController.swift
//  Medicine Reminder
//
//  Created by Omer on 13.05.2024.
//

import Foundation

class LocalTimeController {
    static let shared = LocalTimeController()
 
    func getLocalTime(date: Date) -> Date{
        let currentDate = date
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: currentDate)
        let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: currentDate)
         
         return localDate
    }
}
