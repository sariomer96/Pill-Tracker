

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
    
    func configure(with countdown: CountDown, reminder: Reminder) {
         self.countdown = countdown
        print("update")
        countdown.startCountdown() {
             [weak self] in
            DispatchQueue.main.async {
          
                self?.updateLabel()
            }
        }

     }

     func updateLabel() {
         if let countdown = countdown {
          
             remainingTimeLabel.text = String(format: "%02d Saat  %02d Dakika %02d Saniye", countdown.hoursLeft, countdown.minutesLeft, countdown.secondsLeft)
         }
     }

     override func prepareForReuse() {
         super.prepareForReuse()
         countdown?.stopTimer()
         remainingTimeLabel.text = nil
        
     }

     
   
    // Geri sayımı başlatan fonksiyon
 

    // Örnek kullanım: 2 saat 0 dakika için geri sayım başlat
    

}
