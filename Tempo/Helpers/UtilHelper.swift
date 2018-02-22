import UIKit

class UtilHelper {
    
    // 
    static func attributedStringFromTimeInterval(interval: TimeInterval) -> NSAttributedString {
        
        let timeString = secondsToFormattedTime(seconds: interval)
        
        let fontAttribute = [
            NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .regular)
        ]
        let attributedTimeString = NSAttributedString(
            string: timeString as String,
            attributes: fontAttribute
        )
        return attributedTimeString
    }
    
    // Converts a time in milliseconds into H:MM:SS.MS format
    static func secondsToFormattedTime(seconds: TimeInterval) -> NSString {
        let ti = NSInteger(seconds)
        let ms = Int((seconds.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 60) / 60
        var timeString: NSString
        if hours > 0 {
            timeString = NSString(format: "%d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
        } else {
            timeString = NSString(format: "%d:%0.2d.%0.2d",minutes,seconds,ms)
        }
        
        return timeString
    }
    
}
