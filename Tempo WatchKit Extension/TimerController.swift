
import WatchKit
import Foundation
import AVFoundation

class TimerController: WKInterfaceController {

    @IBOutlet var beepTimeLabel: WKInterfaceLabel!
    @IBOutlet var startButtonGroup: WKInterfaceGroup!
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var resetButton: WKInterfaceButton!
    
    var timer: Timer!
    var counter = 0.0
    var interval = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let interval = context as? Double {
            beepTimeLabel.setText("Beep Time: \(interval) s")
            self.interval = interval
        }
    }
    
    @IBAction func startPressed() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
        startButtonGroup.setHidden(true)
        stopButton.setHidden(false)
    }
    
    @IBAction func stopPressed() {
        timer.invalidate()
        startButtonGroup.setHidden(false)
        stopButton.setHidden(true)
    }

    @IBAction func resetButtonPressed() {
        counter = 0
        timeLabel.setText("00:00.00")
    }
    
    @objc func updateCounter() {
        counter += 0.01
        if counter.remainder(dividingBy: interval).rounded(toPlaces: 2) == 0 {
            WKInterfaceDevice.current().play(.failure)
            //AudioManager.shared.playBeep()
        }
        let timeSting = stringFromTimeInterval(interval: counter)
        timeLabel.setAttributedText(timeSting)
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> NSAttributedString {
        
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
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
