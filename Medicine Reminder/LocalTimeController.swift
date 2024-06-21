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
    
    func getTotalSeconds(currentDate: Date , targetDate: Date) -> Int {
        let calendar = Calendar.current
        let dayOfWeek1 = calendar.component(.weekday, from: currentDate)
        let dayOfWeek2 = calendar.component(.weekday, from: targetDate)

        let hour1 = calendar.component(.hour, from: currentDate)
        let hour2 = calendar.component(.hour, from: targetDate)

        let minute1 = calendar.component(.minute, from: currentDate)
        let minute2 = calendar.component(.minute, from: targetDate)

        let second1 = calendar.component(.second, from: currentDate)
        let second2 = calendar.component(.second, from: targetDate)

        // Gün, saat, dakika ve saniye farklarını hesaplayalım
        var dayDifference = dayOfWeek2 - dayOfWeek1
        if dayDifference < 0 {
            dayDifference += 7
        }

        var hourDifference = hour2 - hour1
        if hourDifference < 0 {
            hourDifference += 24
            dayDifference = (dayDifference - 1 + 7) % 7
        }

        var minuteDifference = minute2 - minute1
        if minuteDifference < 0 {
            minuteDifference += 60
            hourDifference = (hourDifference - 1 + 24) % 24
        }

        var secondDifference = second2 - second1
        if secondDifference < 0 {
            secondDifference += 60
            minuteDifference = (minuteDifference - 1 + 60) % 60
        }

        // Farkı saniyeye çevirelim
        let totalSeconds = dayDifference * 86400 + hourDifference * 3600 + minuteDifference * 60 + secondDifference
         
      return totalSeconds
        
    }
}
