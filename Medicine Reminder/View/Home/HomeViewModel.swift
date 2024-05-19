

import Foundation
import CoreData
import UserNotifications

class HomeViewModel {
    
    var reminders = [Reminder]()
    func fetchReminders(context: NSManagedObjectContext) {
       
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            reminders = try context.fetch(fetchRequest)
            for i in reminders {
                print("\(i.name)---- \(i.days) -----   START HOUR \(i.startHour)  ------    FREQ \(i.reminderFrequency)")
            }
        } catch {
            print("Error fetching reminders: \(error.localizedDescription)")
        }
        
      
    }
    
    
    func convertHour (date: Date) -> String {
        
        
        // DateFormatter oluştur ve formatını ayarla
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let timeString = dateFormatter.string(from: date)
        return timeString
        
    }
    
    
    func timeDifference(from startTime: String, to endTime: String) -> (hours: Int, minutes: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return nil
        }
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: start)
        let endComponents = calendar.dateComponents([.hour, .minute], from: end)
        
        guard let startHour = startComponents.hour, let startMinute = startComponents.minute,
              let endHour = endComponents.hour, let endMinute = endComponents.minute else {
            return nil
        }
        
        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        var differenceMinutes = endTotalMinutes - startTotalMinutes
        
        // Eğer fark negatifse, 24 saat ekleyin
        if differenceMinutes < 0 {
            differenceMinutes += 24 * 60
        }
        
        let hours = differenceMinutes / 60
        let minutes = differenceMinutes % 60
        
        return (hours, minutes)
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
    func findClosestFutureHour(dates: [Date], from current: Date) -> Date? {
        let futureDates = dates.filter { $0 > current }
            
           if futureDates.isEmpty {
     
               let closestDate = dates.min(by: { abs($0.timeIntervalSince(current)) < abs($1.timeIntervalSince(current)) })
               return closestDate
           } else {
               return futureDates.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) })
           }
    }
}
