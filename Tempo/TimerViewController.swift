import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var stopStackView: UIStackView!
    
    @IBOutlet weak var lapView: UIView!
    @IBOutlet weak var lapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lapsTapDetectView: UIView!
    @IBOutlet weak var lapTable: UITableView!
    @IBOutlet weak var lapTableHeight: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    
    private var timer: Timer!
    private var counter = 0.0
    private var lapCounter = 0.0
    var interval = 0.0
    var laps = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopStackView.isHidden = true
        startStackView.isHidden = false
        lapLabel.isHidden = true
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
        
        lapTable.delegate = self
        lapTable.dataSource = self
        lapTable.tableFooterView = UIView()
        
        lapViewTopConstraint.constant = view.frame.height
        lapViewHeight.constant = view.frame.height

        if interval < 60 {
            intervalLabel.text = "Interval: \(interval) s"
        } else {
            intervalLabel.text = "Interval: \(UtilHelper.secondsToFormattedTime(seconds: interval) as String)"
        }
    }
    
    override func viewDidLayoutSubviews() {
        startButton.layer.cornerRadius = startButton.frame.width / 2
        resetButton.layer.cornerRadius = resetButton.frame.width / 2
        stopButton.layer.cornerRadius = stopButton.frame.width / 2
        lapButton.layer.cornerRadius = lapButton.frame.width / 2   
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let timer = timer {
            timer.invalidate()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lapsButtonPressed(_ sender: Any) {
        lapView.isHidden = false
        self.lapViewTopConstraint.constant = 0
        self.lapTableHeight.constant = lapTable.contentSize.height
        UIView.animate(
            withDuration: 0.5,
            delay: 0, 
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.lapView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                self.blurView.alpha = 0.75
        }) { _ in
            let gestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(TimerViewController.didTapOutsideLapView)
            )
            gestureRecognizer.numberOfTapsRequired = 1
            self.lapsTapDetectView.isUserInteractionEnabled = true
            self.lapsTapDetectView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func didTapOutsideLapView() {
        self.lapViewTopConstraint.constant = self.view.frame.height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0.0
        }
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
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        counter = 0
        timeLabel.text = "0:00.00"
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
        laps.removeAll()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        startStackView.isHidden = false
        stopStackView.isHidden = true
    }
    
    @IBAction func lapButtonPressed(_ sender: Any) {
        lapLabel.isHidden = false
        laps.append(lapCounter)
        lapLabel.text = "Lap \(laps.count): \(UtilHelper.secondsToFormattedTime(seconds: lapCounter))"
        lapCounter = 0.0
        lapTable.reloadData()
    }
    
    @objc func updateCounter() {
        counter += 0.01
        lapCounter += 0.01
        let intervalTimeRemaining = counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        if intervalTimeRemaining == 0 {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            // TODO: Play sound
        }
        let percentComplete = Int(((abs(intervalTimeRemaining) / interval)) * 100)
        progressImage.image = UIImage(named: "tempo-phone-progress-\(percentComplete)")
        let timeSting = UtilHelper.attributedStringFromTimeInterval(interval: counter)
        timeLabel.attributedText = timeSting
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = lapTable.dequeueReusableCell(withIdentifier: "lapCell") as? LapCell {
            cell.lapNumberLabel.text = "Lap \(indexPath.row + 1)"
            let lapTime = UtilHelper.secondsToFormattedTime(
                seconds: laps[indexPath.row]
            )
            cell.lapTimeLabel.text = "\(lapTime)"
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
