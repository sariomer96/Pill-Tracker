////
////  RemindersTableViewCell.swift
////  Medicine Reminder
////
////  Created by Omer on 13.05.2024.
////
//
//import UIKit
//
//class RemindersTableViewCell: UITableViewCell {
// 
//    var timer: Timer?
//    @IBOutlet weak var remainingTime: UIDatePicker!
//    @IBOutlet weak var medicineNameLabel: UILabel!
//    @IBOutlet weak var reminderDateLabel: UILabel!
//    @IBOutlet weak var remainingTimeLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//           
//        let defaultDate = Date().addingTimeInterval(3600)
//                  remainingTime.date = defaultDate
//                  startCountdown()
//        // Initialization code
//    }
//
//    @IBAction func dateValueChanged(_ sender: Any) {
//        
//        startCountdown()
//
//    }
//    func startCountdown() {
//           // Mevcut zamanı al
//           let currentDate = Date()
//           // Date Picker'dan seçilen tarihi al
//           let selectedDate = remainingTime.date
//           // Seçilen tarih ile mevcut tarih arasındaki farkı hesapla
//           let timeDifference = selectedDate.timeIntervalSince(currentDate)
//           print("timeDifference  \(timeDifference)")
//           if timeDifference > 0 {
//               print("start")
//               // Eğer fark pozitifse, geri sayımı başlat
//               timer?.invalidate() // Önceki zamanlayıcıyı iptal et
//               timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                   // Geri sayımı güncelle
//                
//                   
//                  let remainingTime = max(timeDifference - timer.fireDate.timeIntervalSinceNow, 0)
//                   print("timer \(remainingTime)")
////                   // Geri sayım tamamlandığında zamanlayıcıyı durdur
//                   print("guncelle \(remainingTime)")
//                   if remainingTime == 0 {
//                       print("stop")
//                       timer.invalidate()
//                   }
//               }
//           } else {
//               print("dur")
//               // Eğer seçilen tarih mevcut tarihten önceyse, geri sayımı durdur
//               timer?.invalidate()
//              
//           }
//       }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//}


import UIKit

class RemindersTableViewCell: UITableViewCell {

    var timer: Timer?
    @IBOutlet weak var remainingTime: UIDatePicker!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let defaultDate = Date().addingTimeInterval(3600)
        
      //  startCountdown()
      //  startCountdown(hours: 1, minutes: 34)
    }

   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   

    // Geri sayımı başlatan fonksiyon
    func startCountdown(hours: Int, minutes: Int) {
        // Toplam süreyi saniye olarak hesapla
        let totalSeconds = (hours * 3600) + (minutes * 60)
        
        // Geri sayım işlemini gerçekleştiren bir zamanlayıcı oluştur
        var remainingSeconds = totalSeconds
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
                
                // Kalan süreyi saat, dakika ve saniye olarak hesapla
                let hoursLeft = remainingSeconds / 3600
                let minutesLeft = (remainingSeconds % 3600) / 60
                let secondsLeft = remainingSeconds % 60
                
                // Kalan süreyi yazdır
               // print(String(format: "%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft))
                self.remainingTimeLabel.text = String(format: "%02d:%02d", hoursLeft, minutesLeft+1)
            } else {
                // Geri sayım bittiğinde zamanlayıcıyı durdur
                timer.invalidate()
                print("Geri sayım bitti!")
            }
        }
        
        // Koşuyu başlatmak için ana çalıştırma döngüsüne zamanlayıcı ekle
        RunLoop.current.add(timer, forMode: .default)
    }

    // Örnek kullanım: 2 saat 0 dakika için geri sayım başlat
    

}
