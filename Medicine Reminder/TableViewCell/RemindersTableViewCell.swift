

import UIKit

class RemindersTableViewCell: UITableViewCell {

    var timer: Timer? 
    var countdown: CountDown?
    var displayLink: CADisplayLink?

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pillImageView: UIImageView!
    
  
    var totalTime = 0
    var isTotal = false
    var thresholdTime = 60
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pillImageView.image = UIImage(named: "pill")
        pillImageView.addBorder(borderWidth: 0.55, borderColor: UIColor.black.cgColor)
        pillImageView.addCorner(radiusRate: 10.0)
        
        remainingTimeLabel.addCorner(radiusRate: 10.0)
        
        dateView.addCorner(radiusRate: 10.0)
    }
    
    func configure(with countdown: CountDown, reminder: Reminder) {
         self.countdown = countdown
        
        self.countdown?.callBackDate = { date in
            self.updateDate(date: date)
        }
       
        countdown.startCountdown() {
             [weak self] in
            DispatchQueue.main.async {
                if self?.isTotal == false {
                    self?.totalTime = countdown.remainingSeconds
                }
                self?.isTotal = true
                self?.updateLabel()
                self?.updateBackgroundColor(currentTime: countdown.remainingSeconds - self!.thresholdTime)
            }
        } 
     }

     func updateLabel() {
         if let countdown = countdown {
             let daysString = countdown.remainingDay > 0 ? String(format: "%d Gun ", countdown.remainingDay) : ""
             let hoursString = countdown.hoursLeft > 0 ? String(format: "%02d Saat ", countdown.hoursLeft) : ""
             remainingTimeLabel.text = String(format: "%@%@%02d Dk. %02d Saniye Kaldi", daysString, hoursString, countdown.minutesLeft, countdown.secondsLeft)
            
         }
     }
    func updateBackgroundColor(currentTime: Int) {
           UIView.animate(withDuration: 1.0) {
               self.remainingTimeLabel.backgroundColor = self.colorForTime(time: currentTime)
           }
       }
    func setRemainingColor(color: UIColor) {
        remainingTimeLabel.backgroundColor = color
    }
    func updateDate(date: String?) {
        guard let countdown = countdown , let unwrappedDate = date else {
             return
         }
         reminderDateLabel.text = unwrappedDate
 
    }
    func colorForTime(time: Int) -> UIColor { 
         
        let percentage = CGFloat(time) / CGFloat(totalTime)
        
        let redValue = 1.0 - percentage
        let greenValue = percentage
        
        return UIColor(red: redValue, green: greenValue, blue: 0.0, alpha: 1.0)
    }

     override func prepareForReuse() {
         super.prepareForReuse()
         countdown?.stopTimer()
         remainingTimeLabel.text = nil
        
     }
}

extension UIColor {
    static func interpolate(from: UIColor, to: UIColor, with percentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = fromRed + (toRed - fromRed) * percentage
        let green = fromGreen + (toGreen - fromGreen) * percentage
        let blue = fromBlue + (toBlue - fromBlue) * percentage
        let alpha = fromAlpha + (toAlpha - fromAlpha) * percentage
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
