
import WatchKit
import Foundation
import AVFoundation

class TimerController: WKInterfaceController {

    @IBOutlet var timerLoopGroup: WKInterfaceGroup!
    @IBOutlet var startButtonGroup: WKInterfaceGroup!
    @IBOutlet var stopButtonGroup: WKInterfaceGroup!
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var intervalLabel: WKInterfaceLabel!
    @IBOutlet var lapLabel: WKInterfaceLabel!
    @IBOutlet var resetButton: WKInterfaceButton!
    @IBOutlet var lapViewSeperator: WKInterfaceSeparator!
    @IBOutlet var lapViewTable: WKInterfaceTable!
    
    var timer: Timer!
    var counter = 0.0
    var lapCounter = 0.0
    var interval = 0.0
    var laps = [Double]()
    var beepedForInterval = false
    var displayingIntervalView = true
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-0")
        lapLabel.setHidden(true)
        lapViewTable.setHidden(true)
        intervalLabel.setHidden(false)
        if let interval = context as? Double {
            self.interval = interval
            var intervalString = ""
            let timeFormatter = NumberFormatter()
            timeFormatter.minimumFractionDigits = 2
            timeFormatter.minimumIntegerDigits = 2
            
            if interval == 0 {
                intervalLabel.setHidden(true)
            } else if interval > 60.0 {
                let intervalMinutes: Int = Int(interval / 60)
                let intervalSeconds = interval.truncatingRemainder(dividingBy: 60).rounded(toPlaces: 2)
                let intervalSecondsString = timeFormatter.string(from: NSNumber(value: intervalSeconds))
                intervalString = "Interval: \(intervalMinutes):" + intervalSecondsString!
            } else {
                intervalString = "Interval: \(interval) s"
            }
            
            let intervalAttributedString = WatchUtilHelper.attributedString(
                string: intervalString,
                withBoldText: "Interval: "
            )
            intervalLabel.setAttributedText(intervalAttributedString)
        }
    }
    
    @IBAction func startButtonPressed() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
        startButtonGroup.setHidden(true)
        stopButtonGroup.setHidden(false)
    }
    
    @IBAction func stopButtonPressed() {
        timer.invalidate()
        startButtonGroup.setHidden(false)
        stopButtonGroup.setHidden(true)
    }

    @IBAction func resetButtonPressed() {
        counter = 0
        timeLabel.setText("0:00.00")
        laps.removeAll()
        if displayingIntervalView {
            timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-0")
        } else {
            updateLapViewTable()
            lapViewSeperator.setWidth(1)
        }
        updateLapViewTable()
        timer.invalidate()
    }
    
    @IBAction func lapButtonPressed() {
        if displayingIntervalView {
            lapLabel.setHidden(false)
        }
        laps.append(lapCounter)
        
        let lapString = "Lap \(laps.count): \(WatchUtilHelper.timeString(forInterval: lapCounter))"
        let lapAttributedString = WatchUtilHelper.attributedString(
            string: lapString,
            withBoldText: "Lap \(laps.count):"
        )
        updateLapViewTable()
        lapLabel.setAttributedText(lapAttributedString)
        lapCounter = 0.0
    }
    
    @objc func updateCounter() {
        counter += 0.01
        lapCounter += 0.01
        
        let intervalTimeRemaining = interval - counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        
        let timeSting = WatchUtilHelper.attributedTimeString(forInterval: counter)
        timeLabel.setAttributedText(timeSting)
        
        guard interval > 0 else { return }
        
        if intervalTimeRemaining < 0.05 && !beepedForInterval {
            beepedForInterval = true
            WKInterfaceDevice.current().play(.failure)
            AudioManager.shared.playBeep()
        } else if intervalTimeRemaining > 0.95 {
            beepedForInterval = false
        }
        updateProgressTracker()
    }
    
    func updateLapViewTable() {
        lapViewTable.setNumberOfRows(laps.count, withRowType: "LapTableRow")
        for (index, lap) in laps.enumerated() {
            let row = lapViewTable.rowController(at: index) as! LapTableRowController
            row.lapNumberLabel.setText("Lap \(index + 1)")
            row.lapTimeLabel.setAttributedText(
                WatchUtilHelper.attributedTimeString(
                    forInterval: lap,
                    withFontSize: 16
                )
            )
        
        }
    }
    
    
    @IBAction func didTapLapTable(_ sender: Any) {
        convertToIntervalView()
    }
    
    @IBAction func didTapTimerLoopGroup(_ sender: Any) {
        if displayingIntervalView {
            convertToLapView()
        } else {
            convertToIntervalView()
        }
    }
    
    func convertToLapView() {
        displayingIntervalView = false
        intervalLabel.setHidden(true)
        lapLabel.setHidden(true)
        timerLoopGroup.setBackgroundImage(nil)
        
        lapViewSeperator.setAlpha(0)
        lapViewSeperator.setHidden(false)
        
        lapViewTable.setAlpha(0)
        lapViewTable.setHidden(false)
        animate(withDuration: 1) {
            self.timeLabel.setVerticalAlignment(.top)
            self.timerLoopGroup.setRelativeHeight(0.25, withAdjustment: 0)
            self.lapViewSeperator.setAlpha(1)
            self.lapViewTable.setAlpha(1)
        }
        updateProgressTracker()
    }
    
    func convertToIntervalView() {
        displayingIntervalView = true
        intervalLabel.setHidden(false)
        if laps.count > 0 {
            lapLabel.setHidden(false)
        }
        lapViewSeperator.setHidden(true)
        animate(withDuration: 1) {
            self.timeLabel.setVerticalAlignment(.center)
            self.lapViewSeperator.setAlpha(0)
            self.lapViewTable.setAlpha(0)
            self.timerLoopGroup.setRelativeHeight(0.8, withAdjustment: 0)
        }
        lapViewTable.setHidden(true)
        lapViewSeperator.setHidden(true)
        updateProgressTracker()
    }
    
    private func updateProgressTracker() {
        guard interval > 0 else { return }
        let intervalProgress = counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        let percentComplete = Int(((abs(intervalProgress) / interval)) * 100)
        if displayingIntervalView {
            print("Loop")
            timerLoopGroup.setBackgroundImageNamed("tempo-watch-progress-\(percentComplete)")
        } else {
            print("Bar")
            lapViewSeperator.setRelativeWidth(CGFloat(percentComplete) / 100.0, withAdjustment: 0)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        WorkoutManager.shared.startWorkout()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
