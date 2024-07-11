

import Foundation
import CoreData
import UserNotifications

final class HomeViewModel {
    
    var callbackCountDown: CallBack<String>?
    var reminders = [Reminder]()
    var countDownList = [CountDown]()
   
    let currentDay = Calendar.current.component(.weekday, from: Date())
    
    let startDate = "startDate"
    func fetchReminders(context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: startDate, ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
                if let fetchedObjects = fetchedResultsController.fetchedObjects {
                     reminders = fetchedObjects
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureCountDownCell(reminder: Reminder, countDownIndex: Int, completion: @escaping (String) -> Void) {
        let hours = reminder.hours as? [Date]
        guard let hours = hours else { return}
        
        let localDate = getLocalDate(date: Date())
        //MARK: FIND CLOSEST HOUR
        
        if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
 
            let closestDay = findClosestDay(days: reminder.days as! [Int]  , currentDay: currentDay, hours: hours )
            let days = reminder.days as! [Int]
            
            countDownList[countDownIndex].setInit(date: closestDate, dayIndex: closestDay!, dayCount: days.count)
            }
         else {
             fatalError(TimerTextUtility.shared.notFoundHour)
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
        
                //MARK: FIND DIFFERENCE
                
                let days = reminder.days as! [Int]
                let countDown = CountDown(date: closestDate, dayIndex: closestDay ?? 1, dayCount: days.count)
            
                countDownList.append(countDown)

            } else {
                fatalError(TimerTextUtility.shared.notFoundFutureHour)
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
                    
                    
                    let title = TimerTextUtility.shared.pillTime
                    let body = reminder.name
                    
                    let isDaily = true
                    let identifier = UUID().uuidString
                    let notificationCenter = UNUserNotificationCenter.current()
                    
                    let content = UNMutableNotificationContent()
                    content.title = title
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
                fatalError("\(TimerTextUtility.shared.invalidTimeFormat) \(currentTime)")
            }
            
            let hour = Calendar.current.date(byAdding: .hour, value: -3, to: i)
            let rmHour = formatter.string(from: hour!)
     
            let timeString2 = rmHour
            guard let time2 = formatter.date(from: timeString2) else {
                fatalError("\(TimerTextUtility.shared.invalidTimeFormat) \(timeString2)")
            }
            if time1 > time2 {
               
            } else if time1 < time2 {
                  isPassed = false
                break
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
}
