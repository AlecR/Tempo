
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
            AudioManager.shared.playBeep()
            AudioManager.shared.audioPlayer.prepareToPlay()
        }
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
