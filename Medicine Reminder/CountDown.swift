 

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
    
    let currentDay = Calendar.current.component(.weekday, from: Date())
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

 
    var daysLeft: Int {
         return remainingSeconds / 86400
     }
    
    var dayss: Int
    init(date: Date, dayIndex: Int, dayCount: Int) {
 
        let now = Date()
        let  n =    LocalTimeController.shared.getLocalTime(date: now)
        let calendar = Calendar.current
       let totalSeconds = LocalTimeController.shared.getTotalSeconds(currentDate: n, targetDate: date)
       
         
        let currentDay = Calendar.current.component(.weekday, from: Date())
       
        var remainingDay = abs(dayIndex - currentDay )
      //  self.remainingSeconds = Int(interval)
        if dayCount == 1 && n > date {
            remainingDay = 6
        }
        
  
        print("dayind \(dayIndex)  curr \(currentDay)")
        
        self.dayss = remainingDay
        
       
         self.remainingSeconds = totalSeconds
        self.hours = (remainingSeconds % 86400) / 3600
        self.minutes = (remainingSeconds % 3600) / 60
        self.seconds = remainingSeconds % 60
        self.date = date
        self.day = dayIndex
     
     }
    
    func setInit(date: Date, dayIndex: Int, dayCount: Int) {
        let now = Date()
        let  n =    LocalTimeController.shared.getLocalTime(date: now)
        let calendar = Calendar.current

        
       let totalSeconds = LocalTimeController.shared.getTotalSeconds(currentDate: n, targetDate: date)
       
        
        let currentDay = Calendar.current.component(.weekday, from: Date())
       
        var remainingDay = abs(dayIndex - currentDay )
      //  self.remainingSeconds = Int(interval)
        if dayCount == 1 && n > date {
            remainingDay = 6
        }
         self.remainingSeconds = totalSeconds
    
        self.dayss = remainingDay
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
