//
//  Extension+UIView.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 6
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 7, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 7, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
