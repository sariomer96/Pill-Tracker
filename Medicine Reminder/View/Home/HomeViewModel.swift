

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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
                if let fetchedObjects = fetchedResultsController.fetchedObjects {
            
                     reminders = fetchedObjects
                    
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
       
        if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
            let index =  weekDay(from: closestDate)
           
            let days = reminder.days as! [Int]
            let countDown = CountDown(date: closestDate, dayIndex: index, dayCount: days.count)
          
            countDownList[countDownIndex].setInit(date: closestDate, dayIndex: index, dayCount: days.count)
         
            }
         else {
            print("Gelecek saat bulunamadı.")
        }
        completion("COMPLETION")
    }
 
    func configureCountDown(completion: @escaping (String) -> Void) {
         
        countDownList.removeAll()
        for reminder in reminders {
  
            guard let days = reminder.days as? [Int] , let hours = reminder.hours as? [Date] else { return }
            let closestDay = findClosestDay(days: days  , currentDay: currentDay, hours: hours )
             
              
            let localDate = getLocalDate(date: Date())
            
            //MARK: FIND CLOSEST HOUR
           
            if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
       
                let index =  weekDay(from: closestDate)
               
                //MARK: FIND DIFFERENCE
                
                var days = reminder.days as! [Int]
                var countDown = CountDown(date: closestDate, dayIndex: closestDay ?? 1, dayCount: days.count)
                print("append \(reminder)")
                countDownList.append(countDown)
//
            } else {
                print("Gelecek saat bulunamadı.")
            }
            //  print(countDownList)
            completion("COMPLETION")
        }
        
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
                        print("work")
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
            
            for day in days{
                for hour in reminder.hours as! [Date] {
                    
                    
                    let calendar = Calendar.current
                     
                    let hours = calendar.component(.hour, from: hour)
                    let minute = calendar.component(.minute, from: hour)
                     
                    let hourInt = Int(hours)
                    let minuteInt = Int(minute)
                    
                    
                    let title = "Ilac Saati"
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
        
         let futureTimes = dates.filter { $0 > current }
         
        if let closestFutureTime = futureTimes.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) }) {
            return closestFutureTime
        }
        return dates.min()
    }
    func findClosestDay(days: [Int], currentDay: Int, hours: [Date]) -> Int? {
   
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        let currentTime = formatter.string(from: now)
 
        var isPassed = true
        for i in hours {
            guard let time1 = formatter.date(from: currentTime) else {
                fatalError("Geçersiz zaman formatı: \(currentTime)")
            }
            
            let hour = Calendar.current.date(byAdding: .hour, value: -3, to: i)
            let rmHour = formatter.string(from: hour!)
     
            let timeString2 = rmHour
            guard let time2 = formatter.date(from: timeString2) else {
                fatalError("Geçersiz zaman formatı: \(timeString2)")
            }
            if time1 > time2 {
               
            } else if time1 < time2 {
                  isPassed = false
                break
                
            } else {
                print("İki zaman eşit")
            }
        }
         
        if isPassed == true && days.count > 1 {
             
            let largerDays = days.filter { $0 > currentDay }
            if let nextDay = largerDays.min() {
               return nextDay
           } else {
               
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

    func weekDay(from date: Date) -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
         
        return weekday
    }
 
}
