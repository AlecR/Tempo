import Foundation
import WatchKit
import UIKit

class WatchUtilHelper {
    
    static func attributedStringFromTimeInterval(interval: TimeInterval) -> NSAttributedString {
        
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let timeString = NSString(format: "%d:%0.2d.%0.2d",minutes,seconds,ms)
        
        var labelFontSize: CGFloat
        switch WKInterfaceDevice.currentResolution() {
        case .Watch38mm:
            labelFontSize = 27
        case .Watch42mm:
            labelFontSize = 33
        case .Unknown:
            labelFontSize = 27
        }
        
        let fontAttribute = [
            NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: labelFontSize, weight: .regular)
        ]
        let attributedTimeString = NSAttributedString(
            string: timeString as String,
            attributes: fontAttribute
        )
        return attributedTimeString
    }
    
}
