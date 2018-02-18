import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var stopStackView: UIStackView!
    
    private var timer: Timer!
    private var counter = 0.0
    var interval = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = startButton.frame.width / 2
        resetButton.layer.cornerRadius = resetButton.frame.width / 2
        stopButton.layer.cornerRadius = stopButton.frame.width / 2
        lapButton.layer.cornerRadius = lapButton.frame.width / 2
        stopStackView.isHidden = true
        startStackView.isHidden = false
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
        startStackView.isHidden = true
        stopStackView.isHidden = false
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        startStackView.isHidden = false
        stopStackView.isHidden = true
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        counter = 0
        timeLabel.text = "0:00.00"
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
    }
    
    @objc func updateCounter() {
        counter += 0.01
        let intervalTimeRemaining = counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        if intervalTimeRemaining == 0 {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            //AudioManager.shared.playBeep()
            //AudioManager.shared.audioPlayer.prepareToPlay()
        }
        let percentComplete = Int(((abs(intervalTimeRemaining) / interval)) * 100)
        progressImage.image = UIImage(named: "tempo-phone-progress-\(percentComplete)")
        let timeSting = UtilHelper.attributedStringFromTimeInterval(interval: counter)
        timeLabel.attributedText = timeSting
    }
}
