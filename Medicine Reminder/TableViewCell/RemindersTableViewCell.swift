

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
        
        self.countdown?.callBackDate = { date in
            self.updateDate(date: date)
        }
       
        countdown.startCountdown() {
             [weak self] in
            DispatchQueue.main.async {
          
               self?.updateLabel()
            }
        } 
     }

     func updateLabel() {
         if let countdown = countdown {
             let daysString = countdown.dayss > 0 ? String(format: "%d Gun ", countdown.dayss) : ""
             let hoursString = countdown.hoursLeft > 0 ? String(format: "%02d Saat ", countdown.hoursLeft) : ""
             remainingTimeLabel.text = String(format: "%@%@%02d Dk. %02d Saniye Kaldi", daysString, hoursString, countdown.minutesLeft, countdown.secondsLeft)
         }
     }
    
    func updateDate(date: String?) {
        guard let countdown = countdown else {
             return
         }
         
         guard let unwrappedDate = date else {
             print("Date is nil")
             return
         }
         
         // Opsiyonel ibaresi olmadan doğrudan `unwrappedDate` kullanılır
         reminderDateLabel.text = unwrappedDate
 
    }

     override func prepareForReuse() {
         super.prepareForReuse()
         countdown?.stopTimer()
         remainingTimeLabel.text = nil
        
     }
    

}
