//
//  ViewController.swift
//  Tempo
//
//  Created by Alec Rodgers on 2/12/18.
//  Copyright © 2018 Alec Rodgers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timePicker: UIPickerView!
    
    var minutesValues = Array(0...999)
    var secondsValues = Array(0...59)
    var millisecondsValues = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for ms in stride(from: 0, to: 96, by: 5) {
            let value = Double(ms) / 100
            millisecondsValues.append(value)
        }
        
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    
    func addLabelsToPicker() {
        let minsLabel = UILabel()
        minsLabel.text = "mins"
        
        let secLabel = UILabel()
        secLabel.text = "sec"
        
        let msLabel = UILabel()
        msLabel.text = "ms"
        
        timePicker.setPickerLabels(labels: [0: minsLabel, 1: secLabel, 2: msLabel], containedView: view)
        
    }

    override func viewDidLayoutSubviews() {
        addLabelsToPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addLabelsToPicker()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minutesValues.count
        case 1:
            return secondsValues.count
        case 2:
            return millisecondsValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let msFormatter = NumberFormatter()
        msFormatter.minimumIntegerDigits = 0
        msFormatter.minimumFractionDigits = 2
        msFormatter.maximumFractionDigits = 2
        
        let componentWidth = pickerView.frame.width / CGFloat(pickerView.numberOfComponents)
        
        // Label Configuartion
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = .right
        pickerLabel.font = UIFont.systemFont(ofSize: 24)
        let labelWidth = componentWidth / 2
        let pickerLabelX = pickerView.frame.origin.x * CGFloat(component) - 8
        let pickerLabelY = (pickerView.frame.size.height / 2) - (pickerLabel.font.pointSize / 2)
        
        // Containing view configuration
        let containerView = UIView()
        containerView.frame = CGRect(
            x: pickerLabelX,
            y: pickerLabelY,
            width: componentWidth,
            height: pickerLabel.font.pointSize
        )
        containerView.addSubview(pickerLabel)
        
        
        pickerLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: labelWidth,
            height: pickerLabel.font.pointSize
        )
        
        switch component {
        case 0:
            pickerLabel.text = "\(minutesValues[row])"
        case 1:
            pickerLabel.text = "\(secondsValues[row])"
        case 2:
            pickerLabel.text = msFormatter.string(from: millisecondsValues[row] as NSNumber)
        default:
            pickerLabel.text = "?"
        }
        return containerView
    }

}

