import WatchKit
import Foundation

class MainMenuController: WKInterfaceController {

    @IBOutlet var beginButton: WKInterfaceButton!
    
    @IBOutlet var intervalLabel: WKInterfaceLabel!
    @IBOutlet var minutesPicker: WKInterfacePicker!
    @IBOutlet var secondsPicker: WKInterfacePicker!
    @IBOutlet var millisecondsPicker: WKInterfacePicker!
    
    var minutesValue = 0.0
    var secondsValue = 0.0
    var millisecondsValue = 0.0
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var secondsValues = [WKPickerItem]()
        var millisecondsValues = [WKPickerItem]()
        var minutesValues = [WKPickerItem]()
        
        for minutes in 0...999 {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(minutes)"
            pickerItem.caption = "MIN"
            minutesValues.append(pickerItem)
            
        }
        
        for seconds in 0...59 {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(seconds)"
            pickerItem.caption = "SEC"
            secondsValues.append(pickerItem)
        }
        
        for milliseconds in stride(from: 0, to: 96, by: 5) {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(milliseconds)"
            pickerItem.caption = "MS"
            millisecondsValues.append(pickerItem)
        }
        
        minutesPicker.setItems(minutesValues)
        secondsPicker.setItems(secondsValues)
        millisecondsPicker.setItems(millisecondsValues)
        
        minutesPicker.focus()
    }
    
    override func willActivate() {
        WorkoutManager.shared.endWorkout()
        updateLabelValue()
    }
    
    @IBAction func minutesPickerValueChanged(_ value: Int) {
        minutesValue = Double(value)
        updateLabelValue()
    }
    
    @IBAction func secondsPickerValueChanged(_ value: Int) {
        secondsValue = Double(value)
        updateLabelValue()
    }
    
    @IBAction func millisecondsPickerValueChanged(_ value: Int) {
        millisecondsValue = (Double(value*5) / 100).rounded(toPlaces: 2)
        updateLabelValue()
    }
    
    func updateLabelValue() {
        let interval =  (minutesValue * 60) + secondsValue + millisecondsValue
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
    
    @IBAction func beginPressed() {
        let beepInterval = secondsValue + millisecondsValue
        presentController(withName: "TimerController", context: beepInterval)
    }
}
