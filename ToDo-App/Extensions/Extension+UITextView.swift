//
//  Extension+UITextView.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

extension UITextView {
    
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 5)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        self.addSubview(placeholderLabel)
    }
    
    func removePlaceholder() {
        self.viewWithTag(100)?.removeFromSuperview()
    }
}
