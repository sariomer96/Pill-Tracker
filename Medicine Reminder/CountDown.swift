//
//  CountDown.swift
//  Medicine Reminder
//
//  Created by Omer on 19.05.2024.
//

import Foundation

class CountDown {
    
    var timer: Timer?
    var hours: Int
    var minutes: Int
    
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

      init(hours: Int, minutes: Int) {
          self.remainingSeconds = (hours * 3600) + (minutes * 60)
          self.hours = hours
          self.minutes = minutes
      }
    
    
    
    func startCountdown(update: @escaping () -> Void) {
        stopTimer()  // Önceki timer'ı durdur
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    if self.remainingSeconds > 0 {
                        self.remainingSeconds -= 1
                    } else {
                        timer.invalidate()
                        self.timer = nil
                        print("Geri sayım bitti!")
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
