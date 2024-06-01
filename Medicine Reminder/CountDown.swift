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
   // var days: Int
    var minutes: Int
    var seconds: Int
    var remainingSeconds: Int
    var date:Date
    var day: Int
    var hoursLeft: Int {
          return remainingSeconds / 3600
      }
      
      var minutesLeft: Int {
          return (remainingSeconds % 3600) / 60
      }
      
      var secondsLeft: Int {
          return remainingSeconds % 60
      }

    init(  hours: Int, minutes: Int, seconds: Int, date:Date, day: Int) {
          self.remainingSeconds = (hours * 3600) + (minutes * 60) + seconds
          self.hours = hours
          self.minutes = minutes
          self.seconds = seconds
          self.date = date
          self.day = day
        
         // print("init sec \(self.remainingSeconds) \(hours) \(minutes)")
      }
    
    func setInit(hours: Int, minutes: Int, seconds: Int, date: Date, day: Int) {
        self.remainingSeconds = (hours * 3600) + (minutes * 60) + seconds
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.date = date
        self.day = day
       // print("remainingSec \(self.remainingSeconds)   hours : \(hours)  minutes \(minutes)")
    }
 
    
    func startCountdown( update: @escaping () -> Void ) {
           
           // start()
        if day < 1 {
            self.callBackDate?("\(days[0])  \(date)")
        } else {
            self.callBackDate?("\(days[day-1])  \(date)")
        }
           
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
      print("stop")
            timer?.invalidate()
            timer = nil
        }
}
