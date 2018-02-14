import Foundation
import UIKit

class UtilHelper {
    
    static func attributedStringFromTimeInterval(interval: TimeInterval) -> NSAttributedString {
        
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let timeString = NSString(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,ms)
        
        let fontAttribute = [
            NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: 33, weight: .regular)
        ]
        let attributedTimeString = NSAttributedString(
            string: timeString as String,
            attributes: fontAttribute
        )
        return attributedTimeString
    }
    
}
