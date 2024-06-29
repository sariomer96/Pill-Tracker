
import Foundation
import UIKit
class ExtensionLearn: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let radius = CGFloat(10)
    let borderColor = UIColor.black.cgColor
    override func viewDidLoad() {
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        
        label.addCorner(radiusRate: radius)
            //  button.addBorder(borderWidth: 1, borderColor: borderColor)
    }
}


 extension UIView {
    
    func addBorder( borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
     
    func addCorner(radiusRate: CGFloat) {
        self.layer.cornerRadius = radiusRate
        self.layer.masksToBounds = true
    }
 
}

 

