import UIKit

class LapCell: UITableViewCell {

    @IBOutlet weak var lapNumberLabel: UILabel!
    @IBOutlet weak var lapTimeLabel: UILabel!
    @IBOutlet weak var lapDifferenceLabel: UILabel!
    @IBOutlet weak var lapCellStackView: UIStackView!
    
    func configureCell(forLaps laps: [Double], atIndex index: Int) {
        
        lapNumberLabel.textColor = .white
        lapTimeLabel.textColor = .white
        
        lapNumberLabel.text = "Lap \(index + 1)"
        lapTimeLabel.text = "\(UtilHelper.secondsToFormattedTime(seconds: laps[index]))"
        if index > 0 {
            let lapDifference = laps[index] - laps[index - 1]
            let differenceString = UtilHelper.secondsToFormattedTime(seconds: abs(lapDifference))
            lapDifferenceLabel.isHidden = false
            lapDifferenceLabel.text = "\(differenceString)"
            if lapDifference < 0 {
                lapDifferenceLabel.text = "- \(differenceString)"
                lapDifferenceLabel.textColor = .green
            } else if lapDifference > 0 {
                lapDifferenceLabel.text = "+ \(differenceString)"
                lapDifferenceLabel.textColor = .red
            } else {
                lapDifferenceLabel.text = "-"
                lapDifferenceLabel.textColor = .white
            }
        } else {
            lapDifferenceLabel.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
