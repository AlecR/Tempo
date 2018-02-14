import WatchKit
import Foundation

class MainMenuController: WKInterfaceController {

    @IBOutlet var beginButton: WKInterfaceButton!
    
    @IBOutlet var secondsPicker: WKInterfacePicker!
    @IBOutlet var millisecondsPicker: WKInterfacePicker!
    
    var secondsValue = 0.0
    var millisecondsValue = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var secondsValues = [WKPickerItem]()
        var millisecondsValues = [WKPickerItem]()
        
        for seconds in 0...999 {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(seconds)"
            pickerItem.caption = "Seconds"
            secondsValues.append(pickerItem)
        }
        
        for milliseconds in stride(from: 0, to: 96, by: 5) {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(milliseconds)"
            pickerItem.caption = "Milliseconds"
            millisecondsValues.append(pickerItem)
        }
        secondsPicker.setItems(secondsValues)
        millisecondsPicker.setItems(millisecondsValues)
    }
    
    override func willActivate() {
        WorkoutManager.shared.endWorkout()
    }
    
    @IBAction func secondsPickerValueChanged(_ value: Int) {
        secondsValue = Double(value)
    }
    
    @IBAction func millisecondsPickerValueChanged(_ value: Int) {
        millisecondsValue = (Double(value*5) / 100).rounded(toPlaces: 2)
    }
    
    @IBAction func beginPressed() {
        let beepInterval = secondsValue + millisecondsValue
        presentController(withName: "TimerController", context: beepInterval)
    }
}
