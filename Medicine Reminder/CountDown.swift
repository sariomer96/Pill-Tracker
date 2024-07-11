 

import Foundation

final class CountDown {
    
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
    
   let currentDay = Calendar.current.component(.weekday, from: Date())
 
    var hoursLeft: Int {
        return (remainingSeconds % 86400) / 3600
      }
      
    var minutesLeft: Int {
        return (remainingSeconds % 3600) / 60
      }
      
      var secondsLeft: Int {
          return remainingSeconds % 60
      }
    
    var daysLeft: Int {
         return remainingSeconds / 86400
     }
    
    var remainingDay: Int
    init(date: Date, dayIndex: Int, dayCount: Int) {
         
        let now = Date()
        let  n =    LocalTimeController.shared.getLocalTime(date: now)
    
       let totalSeconds = LocalTimeController.shared.getTotalSeconds(currentDate: n, targetDate: date)
        
         var index = currentDay
        var count = 0
         
        for _ in days {
            
            if index == dayIndex {
                break
            }
            
            if index == 7 {
                index = 0
            }
            index += 1
            count += 1
        }
 
        if dayCount == 1 {
            let saat = LocalTimeController.shared.getLocalTime(date: Date())
            let result = LocalTimeController.shared.hourCompare(saat1: saat, saat2: date)
 
            switch result {
            case .orderedDescending:
                count = 7
            default: break
            }
        }
    
        var remainingDay = count - 1
         
        if remainingDay < 0 {
            remainingDay = 0
        }
        self.remainingDay = remainingDay
        self.remainingSeconds = totalSeconds + remainingDay * 86400
        self.hours = (remainingSeconds % 86400) / 3600
        self.minutes = (remainingSeconds % 3600) / 60
        self.seconds = remainingSeconds % 60
        self.date = date
        self.day = dayIndex
     }
    
    func setInit(date: Date, dayIndex: Int, dayCount: Int) {
        let now = Date()
        let  currDate =    LocalTimeController.shared.getLocalTime(date: now)
     
       let totalSeconds = LocalTimeController.shared.getTotalSeconds(currentDate: currDate, targetDate: date)
        
        var index = currentDay
       var count = 0
        for _ in days {
        
           if index == dayIndex {
               break
           }
        
           if index == 7 {
               index = 0
           }
           index += 1
           count += 1
       }
        if dayCount == 1 {
            let saat = LocalTimeController.shared.getLocalTime(date: Date())
            let sonuc = LocalTimeController.shared.hourCompare(saat1: Date(), saat2: date)

            switch sonuc {
            case .orderedAscending:
                count = 7
            default: break
                
            }
        }
    
        var remainingDay = count - 1
         
        if remainingDay < 0 {
            remainingDay = 0
        }
        
        self.remainingDay = remainingDay
        self.remainingSeconds = totalSeconds + remainingDay * 86400
    
      
         self.hours = (remainingSeconds % 86400) / 3600
         self.minutes = (remainingSeconds % 3600) / 60
         self.seconds = remainingSeconds % 60
         self.date = date
         self.day = dayIndex
    }
  
    func startCountdown( update: @escaping () -> Void ) {
           
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
       
        guard let date = date else { return }
        if let correctedDate = Calendar.current.date(byAdding: .hour, value: -3, to: date) {
            let dateStr = dateFormatter.string(from: correctedDate)
                self.callBackDate?("\(days[day-1])\n \(dateStr)")
        }
           stopTimer()
                 
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    if self.remainingSeconds > 0 {
                        self.remainingSeconds -= 1
                    } else {
                        self.callBack?("callback")
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
