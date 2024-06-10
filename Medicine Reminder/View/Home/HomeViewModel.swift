

import Foundation
import CoreData
import UserNotifications

class HomeViewModel {
    
    var callbackCountDown: CallBack<String>?
    var reminders = [Reminder]()
    var countDownList = [CountDown]()
   
    let currentDay = Calendar.current.component(.weekday, from: Date())
    
    func fetchReminders(context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            reminders = try context.fetch(fetchRequest)
            for i in reminders {
                //  print("\(i.name)---- \(i.days) -----   START HOUR \(i.startHour)  ------    FREQ \(i.reminderFrequency)")
            }
        } catch {
            print("Error fetching reminders: \(error.localizedDescription)")
        }
    }
    func configureCountDownCell(reminder: Reminder, countDownIndex: Int, completion: @escaping (String) -> Void) {
        let hours = reminder.hours as? [Date]
        guard let hours = hours else { return print("else") }
        let localDate = getLocalDate(date: Date())
        //MARK: FIND CLOSEST HOUR
        // print("hours: \(hours)         localdate: \(localDate)")
        if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
            let index =  weekDay(from: closestDate)
           
            //MARK: FIND DIFFERENCE
            let strCurr = convertHour(date: localDate)
            let strClosest = convertHour(date: closestDate)
            
            let countDown = CountDown(date: closestDate, dayIndex: index)
            //  let countDown = CountDown(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds)
            
            countDownList[countDownIndex].setInit(date: closestDate, dayIndex: index)
            
            if let difference = timeDifference(from: strCurr, to: strClosest),  let closestDay =  findClosestDay(days: reminder.days as! [Int], currentDay: currentDay) {
                
                let remainingDay = abs(currentDay-closestDay)
           
                
            } else {
                print("Geçersiz saat formatı")
            }
        } else {
            print("Gelecek saat bulunamadı.")
        }
        //  print(countDownList)
        completion("COMPLETION")
    }
    
    func isFutureTime(currentDay: Date, closestDay: Date) -> Bool {
        return  currentDay > closestDay
    }
    func configureCountDown(completion: @escaping (String) -> Void) {
         
        countDownList.removeAll()
        for reminder in reminders {
          
//            var closestDay =   findClosestDay(days: reminder.days as? [Int] ?? [1,2,3,4,5,6,7], currentDay: currentDay)
            
            
            var closestDay = findClosestDay(days: reminder.days as! [Int], currentDay: currentDay, hours: reminder.hours as! [Date] )
            print("closestDay \(closestDay)")
            let hours = reminder.hours as? [Date]
            guard let hours = hours else { return print("else") }
            let localDate = getLocalDate(date: Date())
            
            //MARK: FIND CLOSEST HOUR
           
            if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
       
                let index =  weekDay(from: closestDate)
                print("closestDate \(reminder.days)")
                //MARK: FIND DIFFERENCE
                let strCurr = convertHour(date: localDate)
                let strClosest = convertHour(date: closestDate)
              //   print("closestDAy \(closestDay)")
                
                var countDown = CountDown(date: closestDate, dayIndex: closestDay ?? 1)
                countDownList.append(countDown)
                if let difference = timeDifference(from: strCurr, to: strClosest) {
                    
                    var remainingDay = abs(currentDay-(closestDay ?? 0))-1
                    
                    if remainingDay == 0 {
                        let result =  isFutureTime(currentDay: localDate, closestDay: closestDate)
                         print("RESULt \(result)")
                        if result == true {
                            remainingDay = 6
                        }
                    }
//                    var countDown = CountDown(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds, date: closestDate, day: closestDay ?? 0, remainingDay: remainingDay)
                    
//                    var countDown = CountDown(date: closestDate )
//                    countDownList.append(countDown)
                } else {
                    print("Geçersiz saat formatı")
                }
            } else {
                print("Gelecek saat bulunamadı.")
            }
            //  print(countDownList)
            completion("COMPLETION")
        }
        
    }
    
    func convertHour (date: Date) -> String { //saniyenin de onemi var degis
        
        
        // DateFormatter oluştur ve formatını ayarla
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let timeString = dateFormatter.string(from: date)
        return timeString
        
    }
   
    func timeDifference(from startTime: String, to endTime: String) -> (hours: Int, minutes: Int, seconds: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return nil
        }
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute, .second], from: start)
        let endComponents = calendar.dateComponents([.hour, .minute, .second], from: end)
        
        guard let startHour = startComponents.hour, let startMinute = startComponents.minute, let startSecond = startComponents.second,
              let endHour = endComponents.hour, let endMinute = endComponents.minute, let endSecond = endComponents.second else {
            return nil
        }
        
        let startTotalSeconds = startHour * 3600 + startMinute * 60 + startSecond
        let endTotalSeconds = endHour * 3600 + endMinute * 60 + endSecond
        var differenceSeconds = endTotalSeconds - startTotalSeconds
         
        if differenceSeconds < 0 {
            differenceSeconds += 24 * 3600
        }
        
        let hours = differenceSeconds / 3600
        let minutes = (differenceSeconds % 3600) / 60
        let seconds = differenceSeconds % 60
        
        return (hours, minutes, seconds)
    }
    
    func getLocalDate(date: Date) -> Date {
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: date)
        let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: date)
        return localDate
    }
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                        
                    }
                    
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotification()
                
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        
        for reminder in reminders {
            let days = reminder.days as? [Int]
            guard let days = days else {continue}
            //print("REM \(i)")
            for day in days{
                for hour in reminder.hours as! [Date] {
                    
                    
                    let calendar = Calendar.current
                    
                    _ = TimeZone.current
                    
                    // Yerel zaman dilimine göre saat ve dakika bileşenlerini al
                    let hours = calendar.component(.hour, from: hour)
                    let minute = calendar.component(.minute, from: hour)
                    
                    // Saat ve dakikayı ayrı ayrı int'e dönüştür
                    let hourInt = Int(hours)
                    let minuteInt = Int(minute)
                    
                    
                    let title = "tTEST TITLE"
                    let body = reminder.name
                    
                    let isDaily = true
                    let identifier = UUID().uuidString
                    let notificationCenter = UNUserNotificationCenter.current()
                    
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = body ?? "AAAA"
                    content.sound = .default
                    
                    
                    var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
                    
                    dateComponents.hour = hourInt-3
                    dateComponents.minute = minuteInt
                    dateComponents.weekday = day
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
                    notificationCenter.add(request)
                }
            }
            
            
            
            
        }
    }
    func findClosestFutureHour(dates: [Date], from current: Date) -> Date? {
        // Geçmemiş gelecekteki saatleri bul
         let futureTimes = dates.filter { $0 > current }
        
        // Eğer geçmemiş gelecekteki saatler varsa, en yakın olanı döndür
        if let closestFutureTime = futureTimes.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) }) {
            return closestFutureTime
        }
         
        // Eğer geçmemiş gelecekteki bir saat bulunamazsa, listedeki en eski saat döndürülür
        return dates.min()
    }
    func findClosestDay(days: [Int], currentDay: Int, hours: [Date]) -> Int? {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        let currentTime = formatter.string(from: now)
 
        var isPassed = true
        for i in hours {
            guard let time1 = formatter.date(from: currentTime) else {
                fatalError("Geçersiz zaman formatı: \(currentTime)")
            }
            
            let aa = Calendar.current.date(byAdding: .hour, value: -3, to: i)
            let ct = formatter.string(from: aa!)
            print("CT \(ct)")
            // İkinci zamanı oluştur
            let timeString2 = ct
            guard let time2 = formatter.date(from: timeString2) else {
                fatalError("Geçersiz zaman formatı: \(timeString2)")
            }
            
            
            // Zamanları karşılaştır
            if time1 > time2 {
                print(" Simdiki zaman \(currentTime) ileride")
            } else if time1 < time2 {
                  isPassed = false
                break
                print("listedeki saat : \(timeString2) ileride")
            } else {
                print("İki zaman eşit")
            }
        }
        
        print(isPassed)
     

         
 
        // Bugünden büyük olan günleri filtrele
        if isPassed == true && days.count > 1 {
            print("CUURDDAY \(currentDay)")
            let largerDays = days.filter { $0 > currentDay }
            if let nextDay = largerDays.min() {
               return nextDay
           } else {
               // Eğer bugünden büyük gün yoksa, listedeki en küçük günü döndür
               return days.min()
           }
        } else {
            let largerDays = days.filter { $0 >= currentDay }
            if let nextDay = largerDays.min() {
               return nextDay
            } else {
                return days[0]
            }
            
        }
       
        
    }





    func findClosestDay(days: [Int], currentDay: Int) -> Int? {
        var closestDay: Int? = nil
       
        // Bugünden büyük olan günleri filtrele
        let largerDays = days.filter { $0 > self.currentDay }
        
        // Eğer bugünden büyük günler varsa, en küçüğünü bul
        if let nextDay = largerDays.min() {
            closestDay = nextDay
        } else {
            // Bugünden büyük gün yoksa, listedeki en küçük günü bul
            if let nextWeekDay = days.min() {
                closestDay = nextWeekDay
            }
        }
        
        return closestDay
    }
    
   
    func weekDay(from date: Date) -> Int {
        let calendar = Calendar.current
        var weekday = calendar.component(.weekday, from: date)
        
        // Haftanın ilk günü pazar ve 1 olarak kabul edilir
        // Pazar = 1, Pazartesi = 2, ..., Cumartesi = 7
        // Ancak iOS'in Calendar sınıfında Pazar = 1, Pazartesi = 2, ..., Cumartesi = 7 şeklindedir.
        // Bu nedenle ek bir işlem gerekmez.
        
        // Ancak, haftanın ilk günü pazar olarak kabul edildiğinden ve Swift'te haftanın ilk günü pazar olduğunda bir
        // değişiklik yapmaya gerek yoktur. Ama eğer ihtiyacımız olursa bu dönüşüm eklenebilir.
        return weekday
    }
 
}
