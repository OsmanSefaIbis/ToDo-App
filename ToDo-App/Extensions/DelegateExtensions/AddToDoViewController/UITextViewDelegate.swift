//
//  UITextViewDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

extension AddToDoViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty{
            textView.removePlaceholder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addDescriptionTextView.textColor == UIColor.lightGray {
            addDescriptionTextView.text = nil
            addDescriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addDescriptionTextView.text.isEmpty {
            addDescriptionTextView.removePlaceholder()
            addDescriptionTextView.addPlaceholder("add a description ...")
            addDescriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
