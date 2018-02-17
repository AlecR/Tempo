
import WatchKit
import Foundation
import AVFoundation

class TimerController: WKInterfaceController {

    @IBOutlet var timerLoopGroup: WKInterfaceGroup!
    @IBOutlet var startButtonGroup: WKInterfaceGroup!
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var intervalLabel: WKInterfaceLabel!
    @IBOutlet var resetButton: WKInterfaceButton!
    
    var timer: Timer!
    var counter = 0.0
    var interval = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-0")
        if let interval = context as? Double {
            self.interval = interval
            var intervalString = ""
            let timeFormatter = NumberFormatter()
            timeFormatter.minimumFractionDigits = 2
            timeFormatter.minimumIntegerDigits = 2
            
            if interval > 60.0 {
                let intervalMinutes: Int = Int(interval / 60)
                let intervalSeconds = interval.truncatingRemainder(dividingBy: 60).rounded(toPlaces: 2)
                let intervalSecondsString = timeFormatter.string(from: NSNumber(value: intervalSeconds))
                intervalString = "Interval: \(intervalMinutes):" + intervalSecondsString!
            } else {
                intervalString = "Interval: \(interval) s"
            }
            intervalLabel.setText(intervalString)
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
        timeLabel.setText("0:00.00")
        timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-0")
    }
    
    @objc func updateCounter() {
        counter += 0.01
        let intervalTimeRemaining = counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        if intervalTimeRemaining == 0 {
            WKInterfaceDevice.current().play(.failure)
            AudioManager.shared.playBeep()
            AudioManager.shared.audioPlayer.prepareToPlay()
        }
        let percentComplete = Int(((abs(intervalTimeRemaining) / interval)) * 100)
        timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-\(percentComplete)")
        
        let timeSting = UtilHelper.attributedStringFromTimeInterval(interval: counter)
        timeLabel.setAttributedText(timeSting)
        
    }
    
    override func willActivate() {
        super.willActivate()
        WorkoutManager.shared.startWorkout()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
