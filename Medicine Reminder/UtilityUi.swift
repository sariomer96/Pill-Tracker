
import Foundation
import UIKit


extension UIView {
    func addBorder( borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
    
    func changeBorderColor(width: CGFloat, color: CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    func addCorner(radiusRate: CGFloat) {
        self.layer.cornerRadius = radiusRate
        self.layer.masksToBounds = true
    }
 
}
