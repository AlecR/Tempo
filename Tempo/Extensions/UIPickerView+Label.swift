//
//  PickerLabels.swift
//  My Timer
//
//  Created by Luís Machado on 02/02/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//
import Foundation
import UIKit


extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let componentWidth = frame.width / CGFloat(numberOfComponents)
        let labelWidth:CGFloat = componentWidth / 2
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                let labelX = (componentWidth * CGFloat(i)) + (componentWidth / 2) + 8
                label.frame = CGRect(
                    x: labelX,
                    y: y,
                    width: labelWidth,
                    height: fontSize
                )
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.textAlignment = NSTextAlignment.left
                self.addSubview(label)
            }
        }
    }
}
