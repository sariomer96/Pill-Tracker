

import UIKit

class RemindersTableViewCell: UITableViewCell {

    var timer: Timer? 
    var countdown: CountDown?
    var displayLink: CADisplayLink?

    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }

   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with countdown: CountDown) {
         self.countdown = countdown
         updateLabel()
         countdown.startCountdown() { [weak self] in
             DispatchQueue.main.async {
                 self?.updateLabel()
             }
         }
     }

     func updateLabel() {
         if let countdown = countdown {
             remainingTimeLabel.text = String(format: "%02d:%02d:%02d", countdown.hoursLeft, countdown.minutesLeft, countdown.secondsLeft)
         }
     }

     override func prepareForReuse() {
         super.prepareForReuse()
         countdown?.stopTimer()
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
