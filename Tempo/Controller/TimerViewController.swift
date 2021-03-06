import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var lapsTableButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var stopStackView: UIStackView!
    
    @IBOutlet weak var lapsView: UIView!
    @IBOutlet weak var lapsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lapsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lapsTapDetectView: UIView!
    @IBOutlet weak var lapsTable: UITableView!
    @IBOutlet weak var lapsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!

    private var lapCounter = 0.0
    var interval = 0.0
    var laps = [Double]()
    var beepedForInterval = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopStackView.isHidden = true
        startStackView.isHidden = false
        lapLabel.isHidden = true
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
        
        lapsTable.delegate = self
        lapsTable.dataSource = self
        
        TempoTimer.shared.delegate = self
        
        lapsTableButton.isEnabled = false
        lapsTableButton.setTitleColor(.lightGray, for: .disabled)
        lapsTableButton.setTitleColor(.white, for: .normal)
        
        lapsViewTopConstraint.constant = view.frame.height
        lapsViewHeight.constant = view.frame.height
        
        configureTimerLabels()
        
    }
    
    override func viewDidLayoutSubviews() {
        startButton.layer.cornerRadius = startButton.frame.width / 2
        resetButton.layer.cornerRadius = resetButton.frame.width / 2
        stopButton.layer.cornerRadius = stopButton.frame.width / 2
        lapButton.layer.cornerRadius = lapButton.frame.width / 2
        
        configureLapTable()
    }
    
    private func configureTimerLabels() {
        
        let intervalString = "Interval: " as NSString
        let attributedIntervalString = NSMutableAttributedString(
            string: intervalString as String,
            attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20.0)]
        )
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]
        attributedIntervalString.addAttributes(
            boldFontAttribute,
            range: intervalString.range(of: "Interval:")
        )
        
    
        if interval == 0 {
            intervalLabel.isHidden = true
        } else if interval < 60 {
            let interval = NSAttributedString(string: "\(self.interval) s")
            attributedIntervalString.append(interval)
            intervalLabel.attributedText = attributedIntervalString
        } else {
            let interval = NSAttributedString(string: "\(UtilHelper.secondsToFormattedTime(seconds: self.interval) as String)")
            attributedIntervalString.append(interval)
            intervalLabel.attributedText = attributedIntervalString
        }
    }
    
    /*
     Configures and adds a header to the lap table
     TODO: Create a `LapTable` class for the lap table's configuration
     */
    private func configureLapTable() {
        let tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: lapsTable.frame.width,
            height: 60
        ))
        
        let tableHeaderLabel = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: lapsTable.frame.width,
            height: tableHeaderView.frame.height
        ))
        
        let tableFooterView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: lapsTable.frame.width,
            height: 10
        ))
        
        tableHeaderLabel.text = "LAPS"
        tableHeaderLabel.textAlignment = .center
        tableHeaderLabel.font = UIFont.systemFont(ofSize: 30)
        tableHeaderLabel.textColor = .white
        
        tableHeaderView.addSubview(tableHeaderLabel)
        
        lapsTable.tableFooterView = tableFooterView
        lapsTable.tableHeaderView = tableHeaderView
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        lapsTable.backgroundView = blurEffectView
        
    }
    
    // =====================================
    // IBActions
    // =====================================

    @IBAction func cancelButtonPressed(_ sender: Any) {
        TempoTimer.shared.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lapsTableButtonPressed(_ sender: Any) {
        lapsView.isHidden = false
        self.lapsViewTopConstraint.constant = 0
        if lapsTable.contentSize.height < (lapsView.frame.height / 2) - 16 {
            self.lapsTableHeight.constant = lapsTable.contentSize.height
        } else {
            self.lapsTableHeight.constant = (lapsView.frame.height / 2) - 16
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0, 
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.lapsView.layoutIfNeeded()
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
        self.lapsViewTopConstraint.constant = self.view.frame.height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0.0
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        LocalNotificationManager.shared.scheduleSoundNotifications(
            withSecondsInterval: interval
        )
        TempoTimer.shared.start()
        startStackView.isHidden = true
        stopStackView.isHidden = false
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        TempoTimer.shared.resetTimer()
        timeLabel.text = "0:00.00"
        progressImage.image = UIImage(named: "tempo-phone-progress-0")
        laps.removeAll()
        lapsTableButton.isEnabled = false
        lapLabel.isHidden = true
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        TempoTimer.shared.stop()
        startStackView.isHidden = false
        stopStackView.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func lapButtonPressed(_ sender: Any) {
        lapLabel.isHidden = false
        lapsTableButton.isEnabled = true
        lapsTableButton.tintColor = .white
        laps.append(lapCounter.rounded(toPlaces: 2))
        
        let lapString = "Lap \(laps.count): \(UtilHelper.secondsToFormattedTime(seconds: lapCounter))" as NSString
        let lapAttributedString = NSMutableAttributedString(string: lapString as String)
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]
        lapAttributedString.addAttributes(boldFontAttribute, range: lapString.range(of: "Lap \(laps.count):"))
        
        lapLabel.attributedText = lapAttributedString
        lapCounter = 0.0
        lapsTable.reloadData()
    }
}

extension TimerViewController: TempoTimerDelegate {
    func timerDidFire(withCounter counter: Double) {
        lapCounter += 0.01
        let intervalProgress = counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)
        let intervalTimeRemaining = interval - counter.truncatingRemainder(dividingBy: interval).rounded(toPlaces: 2)

        let timeSting = UtilHelper.attributedStringFromTimeInterval(interval: counter)
        timeLabel.attributedText = timeSting

        guard interval > 0 else { return }

        // Counter is imprecise, so `beepedForInterval` is used to make sure
        // only one beep / vibrate is occuring per interval
        if intervalTimeRemaining < 0.05 && !beepedForInterval {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioManager.shared.playBeep()
            beepedForInterval = true
        } else if intervalTimeRemaining > 0.95 {
            beepedForInterval = false
        }

        let percentComplete = Int(((abs(intervalProgress) / interval)) * 100)
        progressImage.image = UIImage(named: "tempo-phone-progress-\(percentComplete)")
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = lapsTable.dequeueReusableCell(withIdentifier: "lapCell") as? LapCell {
            cell.configureCell(forLaps: laps, atIndex: indexPath.row)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
