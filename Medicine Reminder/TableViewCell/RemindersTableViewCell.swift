

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
          
             remainingTimeLabel.text = String(format: "%0d G %02d S %02d D %02d S" , countdown.dayss, countdown.hoursLeft, countdown.minutesLeft, countdown.secondsLeft)
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
