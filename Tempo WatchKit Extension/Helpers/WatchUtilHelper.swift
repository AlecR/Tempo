import Foundation
import WatchKit
import UIKit

class WatchUtilHelper {
    
    static func attributedTimeString(forInterval interval: TimeInterval, withFontSize size: CGFloat?) -> NSAttributedString {
        
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let timeString = NSString(format: "%d:%0.2d.%0.2d",minutes,seconds,ms)
        
        var defaultLabelSize: CGFloat
        switch WKInterfaceDevice.currentResolution() {
        case .Watch38mm:
            defaultLabelSize = 27
        case .Watch42mm:
            defaultLabelSize = 33
        case .Unknown:
            defaultLabelSize = 27
        }
        
        let fontSize = size ?? defaultLabelSize
        
        let fontAttribute = [
            NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        ]
        let attributedTimeString = NSAttributedString(
            string: timeString as String,
            attributes: fontAttribute
        )
        return attributedTimeString
    }
    
}
