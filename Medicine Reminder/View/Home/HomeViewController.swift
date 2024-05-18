//
//  HomeViewController.swift
//  Medicine Reminder
//
//  Created by Omer on 9.05.2024.
//

import UIKit
import CoreData
import UserNotifications

class HomeViewController: BaseViewController {
    let homeViewModel = HomeViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi.")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
        self.tableView.register(UINib(nibName: "RemindersTableViewCell", bundle: nil), forCellReuseIdentifier: "RemindersTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

        checkForPermission()
       // trigger()
         
        // Do any additional setup after loading the view.
    }

    @IBAction func addMedicineClicked(_ sender: Any) {
        let storyBoardID = "MedicineViewController"
        pushViewController(param: MedicineViewController.self, vcIdentifier: storyBoardID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getReminders()
        tableView.reloadData()
    }
    
    func getViewContext() -> NSManagedObjectContext {
        let  appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let appDelegate = appDelegate else {  fatalError("AppDelegate is nil!") }
        let context = appDelegate.persistentContainer.viewContext
        return context
       
    }
    func getReminders() {
    
         let context = getViewContext()
         let reminderList = homeViewModel.fetchReminders(context: context)
        
     
    }
    // Şu anki tarih
    let current = Date()

    // current'tan sonra gelen en yakın saati bulmak için bir fonksiyon
    func findClosestFutureHour(dates: [Date], from current: Date) -> Date? {
        let futureDates = dates.filter { $0 > current }
           
           // Eğer futureDates boşsa, yani sadece geride kalmış tarihler varsa
           if futureDates.isEmpty {
               // current'tan önceki saatlere bakarak en yakını bul
               let closestDate = dates.min(by: { abs($0.timeIntervalSince(current)) < abs($1.timeIntervalSince(current)) })
               return closestDate
           } else {
               // current'tan sonraki saatler varsa, en erken olanı bul
               return futureDates.min(by: { $0.timeIntervalSince(current) < $1.timeIntervalSince(current) })
           }
    }

    // Kullanım

    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // homeViewModel.reminders.count
        return homeViewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTableViewCell", for: indexPath) as! RemindersTableViewCell
        cell.medicineNameLabel.text = homeViewModel.reminders[indexPath.row].name
        
        let hours = homeViewModel.reminders[indexPath.row].hours as? [Date]
        guard let hours = hours else { return UITableViewCell() }
        
        let currentDate = Date()
        
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: currentDate)
        let localDate = Date(timeInterval: TimeInterval(secondsFromGMT), since: currentDate)
        //MARK: FIND CLOSEST HOUR
        if let closestDate = findClosestFutureHour(dates: hours, from: localDate) {
            
            print("closestDate  \(closestDate)")
            let str = convertHour(date: closestDate)
            cell.reminderDateLabel.text = "HATIRLATMA \(str)"
            //MARK: FIND DIFFERENCE
            
            let strCurr = convertHour(date: localDate)
            let strClosest = convertHour(date: closestDate)
            print("strclosest  \(strClosest)    \(closestDate)")
            // Tarihi sadece saat ve dakika olarak string'e dönüştür
            
            
            print("timeString  \(strCurr)      closeststr : \(strClosest)")
            
            
            
            if let difference = timeDifference(from: strCurr, to: strClosest) {
                print("Fark: \(difference.hours) saat \(difference.minutes) dakika")
                cell.startCountdown(hours: difference.hours, minutes: difference.minutes)
            } else {
                print("Geçersiz saat formatı")
            }
            
            
            //MARK: CONVERT HOUR MINUTE
            let curr = closestDate
            
            // Takvim örneği oluştur
            let calendar = Calendar.current
            
            // Saat ve dakikayı al
            let hour = calendar.component(.hour, from: curr)
            let minute = calendar.component(.minute, from: curr)
            //MARK: CONVERT HOUR MINUTE
            
            
            
            
        } else {
            print("Gelecek saat bulunamadı.")
        }
        
        return cell
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
    
    
    
    
    func trigger() {
        print("triggg")
        
        var dateComponents = DateComponents()
         
        dateComponents.hour = 15
        dateComponents.minute = 40
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Hatırlatma"
        content.body =  "BILDIRIM"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            }
            
            
            
            for reminder in self.homeViewModel.reminders {
                print("trigggICERDE")
                for day in reminder.days as! [Int]{
                    for hour in reminder.hours as! [Date] {
                        var dateComponents = DateComponents()
                        
                        let calendar = Calendar.current
                        
                        // Saat ve dakikayı al
                        let resultHour = calendar.component(.hour, from: hour)
                        let minute = calendar.component(.minute, from: hour)
                        
                        // Saat ve dakikayı ayrı ayrı int'e dönüştür
                        let hourInt = Int(resultHour)
                        let minuteInt = Int(minute)
                        
                        dateComponents.weekday = day
                        dateComponents.hour = hourInt
                        dateComponents.minute = minute
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Hatırlatma"
                        content.body =  "BILDIRIM"
                        content.sound = UNNotificationSound.default
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        
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
        let title = "time to woro"
        let body = "dont be laz"
        let hour = 15
        let minute = 41
        let isDaily = true
        let identifier = "my noti"
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}
