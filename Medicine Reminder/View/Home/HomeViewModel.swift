

import Foundation
import CoreData
import UserNotifications

class HomeViewModel {
    
    var callbackCountDown: CallBack<String>?
    var reminders = [Reminder]()
    var countDownList = [CountDown]()
   
    let currentDay = Calendar.current.component(.weekday, from: Date()) - 1
    
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
            
            //MARK: FIND DIFFERENCE
            let strCurr = convertHour(date: localDate)
            let strClosest = convertHour(date: closestDate)
            
            if let difference = timeDifference(from: strCurr, to: strClosest),  let closestDay =  findClosestDay(days: reminder.days as! [Int], currentDay: currentDay) {
              
                //  let countDown = CountDown(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds)
                countDownList[countDownIndex].setInit(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds, date: closestDate, day: closestDay)
                
            } else {
                print("Geçersiz saat formatı")
            }
        } else {
            print("Gelecek saat bulunamadı.")
        }
        //  print(countDownList)
        completion("COMPLETION")
    }
    func configureCountDown(completion: @escaping (String) -> Void) {
        
        // print("tekerar")
        countDownList.removeAll()
        for reminder in reminders {
          
            var closestDay =   findClosestDay(days: reminder.days as? [Int] ?? [0,1,2,3,4,5,6], currentDay: currentDay)
             
            let hours = reminder.hours as? [Date]
            guard let hours = hours else { return print("else") }
            let localDate = getLocalDate(date: Date())
            //MARK: FIND CLOSEST HOUR
          
            if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
                
                //MARK: FIND DIFFERENCE
                let strCurr = convertHour(date: localDate)
                let strClosest = convertHour(date: closestDate)
                
                if let difference = timeDifference(from: strCurr, to: strClosest) {
                 
                    var countDown = CountDown(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds, date: closestDate, day: closestDay ?? 0)
                    
                    countDownList.append(countDown)
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
        
        // Eğer fark negatifse, 24 saat (86400 saniye) ekleyin
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
                    
                    let timeZone = TimeZone.current
                    
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
    
    // current'tan sonra gelen en yakın saati bulmak için bir fonksiyon
    //    func findClosestFutureHour(dates: [Date], from current: Date) -> Date? {
    //        let futureDates = dates.filter { $0 > current }
    //
    //           if futureDates.isEmpty {
    //
    //               let closestDate = dates.min(by: { abs($0.timeIntervalSince(current)) < abs($1.timeIntervalSince(current)) })
    //               return closestDate
    //           } else {
    //               return futureDates.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) })
    //           }
    //    }
    //
    func findClosestFutureHour(dates: [Date], from current: Date) -> Date? {
        // Geçmemiş gelecekteki saatleri bul
        let futureTimes = dates.filter { $0 > current }
        
        // Eğer geçmemiş gelecekteki saatler varsa, en yakın olanı döndür
        if let closestFutureTime = futureTimes.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) }) {
            return closestFutureTime
        }
        
        print("dates \(dates.count)")
        // Eğer geçmemiş gelecekteki bir saat bulunamazsa, listedeki en eski saat döndürülür
        return dates.min()
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
}
