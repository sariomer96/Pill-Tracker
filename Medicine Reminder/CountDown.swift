//
//  CountDown.swift
//  Medicine Reminder
//
//  Created by Omer on 19.05.2024.
//

import Foundation

class CountDown {
    
    let days = [
        "Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"
    ]
    var callBack:CallBack<String>?
    var callBackDate:CallBack<String>?
    var timer: Timer?
    var hours: Int
     
    var minutes: Int
    var seconds: Int
    var remainingSeconds: Int
    var date:Date?
    var day: Int
   // var remainingDay: Int
    var hoursLeft: Int {
         // return remainingSeconds / 3600
        return (remainingSeconds % 86400) / 3600
      }
      
      var minutesLeft: Int {
          return (remainingSeconds % 3600) / 60
          
      }
      
      var secondsLeft: Int {
          return remainingSeconds % 60
      }

//    init(hours: Int, minutes: Int, seconds: Int, date:Date, day: Int, remainingDay: Int) {
//          self.remainingSeconds = (hours * 3600) + (minutes * 60) + seconds
//          self.hours = hours
//          self.minutes = minutes
//          self.seconds = seconds
//          self.date = date
//          self.day = day
//          self.remainingDay = remainingDay
//         
//      }
    var daysLeft: Int {
         return remainingSeconds / 86400
     }
    
    var dayss: Int
    init(date: Date, dayIndex: Int) {
        let now = Date()
        let  n =    LocalTimeController.shared.getLocalTime(date: now)
        let calendar = Calendar.current

        // Calculate the next occurrence of the given date's day and time
        var components = calendar.dateComponents([.weekday, .hour, .minute, .second], from: date)
        components.second = 0

        var nextDate = calendar.nextDate(after: n, matching: components, matchingPolicy: .nextTime)!

        // If the next occurrence is in the past for today, adjust to the next week
        if nextDate < n {
            nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
            
        }

        let interval = nextDate.timeIntervalSince(n)
        self.remainingSeconds = Int(interval)
         self.dayss = remainingSeconds / 86400
         self.hours = (remainingSeconds % 86400) / 3600
         self.minutes = (remainingSeconds % 3600) / 60
         self.seconds = remainingSeconds % 60
         self.date = date
         self.day = dayIndex
        
     }
    
    func setInit(date: Date, dayIndex: Int) {
        let now = Date()
        let  n =    LocalTimeController.shared.getLocalTime(date: now)
        let calendar = Calendar.current

        // Calculate the next occurrence of the given date's day and time
        var components = calendar.dateComponents([.weekday, .hour, .minute, .second], from: date)
        components.second = 0

        var nextDate = calendar.nextDate(after: n, matching: components, matchingPolicy: .nextTime)!

        // If the next occurrence is in the past for today, adjust to the next week
        if nextDate < n {
            nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
            
        }

        let interval = nextDate.timeIntervalSince(n)
        self.remainingSeconds = Int(interval)
         self.dayss = remainingSeconds / 86400
         self.hours = (remainingSeconds % 86400) / 3600
         self.minutes = (remainingSeconds % 3600) / 60
         self.seconds = remainingSeconds % 60
         self.date = date
         self.day = dayIndex
    }
 
    
    func startCountdown( update: @escaping () -> Void ) {
           
    
            self.callBackDate?("\(days[day-1])  \(date!)")
        
           
           stopTimer()  // Önceki timer'ı durdur
                 
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                  //  print(self.remainingSeconds)
                    if self.remainingSeconds > 0 {
                        self.remainingSeconds -= 1
                    } else {
                        print("Geri sayım bitti!")
                        self.callBack?("CALLBACK")
                        timer.invalidate()
                        self.timer = nil
                       
                       
                    }
                    update()
                }
                RunLoop.current.add(timer!, forMode: .default)
    }
    func stopTimer() {
      
            timer?.invalidate()
            timer = nil
        }
}
