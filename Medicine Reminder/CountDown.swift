//
//  CountDown.swift
//  Medicine Reminder
//
//  Created by Omer on 19.05.2024.
//

import Foundation

class CountDown {
    
    var callBack:CallBack<String>?
    var timer: Timer?
    var hours: Int
    var minutes: Int
    var seconds: Int
    var remainingSeconds: Int
    
    var hoursLeft: Int {
          return remainingSeconds / 3600
      }
      
      var minutesLeft: Int {
          return (remainingSeconds % 3600) / 60
      }
      
      var secondsLeft: Int {
          return remainingSeconds % 60
      }

    init(hours: Int, minutes: Int, seconds: Int) {
          self.remainingSeconds = (hours * 3600) + (minutes * 60) + seconds
          self.hours = hours
          self.minutes = minutes
          self.seconds = seconds
         // print("init sec \(self.remainingSeconds) \(hours) \(minutes)")
      }
    
    func setInit(hours: Int, minutes: Int, seconds: Int) {
        self.remainingSeconds = (hours * 3600) + (minutes * 60) + seconds
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
 
    
    func startCountdown( update: @escaping () -> Void ) {
            print("START COUNTD")
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
