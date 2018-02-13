
import WatchKit
import Foundation

class MainMenuController: WKInterfaceController {
    
    @IBOutlet var beepIntervalLabel: WKInterfaceLabel!
    
    var beepInterval = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        crownSequencer.focus()
    }
    
    override func willActivate() {
        crownSequencer.focus()
    }
    
    @IBAction func beginPressed() {
        presentController(withName: "TimerController", context: beepInterval)
    }
    
    override func contextsForSegue(withIdentifier segueIdentifier: String) -> [Any]? {
        return [beepInterval]
    }
}

extension MainMenuController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        beepInterval += (rotationalDelta * 3).rounded(toPlaces: 2)
        while beepInterval.remainder(dividingBy: 0.05).rounded(toPlaces: 2) != 0 {
            if beepInterval > 0 {
                beepInterval += 0.01
            } else {
                beepInterval -= 0.01
            }
            beepInterval = beepInterval.rounded(toPlaces: 2)
        }
        
        if beepInterval < 0 {
            beepInterval = 0.0
        }
        
        let intervalString = String(format: "%.2f s", beepInterval)
        let fontAttribute = [
            NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: 33, weight: .regular)
        ]
        let attributedIntervalString = NSAttributedString(
            string: intervalString as String,
            attributes: fontAttribute
        )
        beepIntervalLabel.setAttributedText(attributedIntervalString)
    }
}
