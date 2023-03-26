//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

protocol ToDoAddedDelegate: AnyObject{
    func didChanged(_ title: String?, _ description: String?)
}

class AddToDoViewController: UIViewController {
    
    // MARK: UI Components
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AddTitleTextField: UITextField!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var AddDescriptionTextView: UITextView!
    @IBOutlet weak var TagsLabel: UILabel!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var CancelToDoButton: UIButton!
    @IBOutlet weak var AddToDoButton: UIButton!
    
    weak var delegate: ToDoAddedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
        
        AddDescriptionTextView.text = "add a description ..."
        AddDescriptionTextView.textColor = .lightGray
    }
    
    @IBAction func CancelToDoButtonPressed(_ sender: Any) {
        dismiss(animated: false)
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
        delegate?.didChanged(AddTitleTextField.text, AddDescriptionTextView.text)
        dismiss(animated: false)
    }
}

extension AddToDoViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if AddDescriptionTextView.textColor == UIColor.lightGray {
            AddDescriptionTextView.text = nil
            AddDescriptionTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if AddDescriptionTextView.text.isEmpty {
            AddDescriptionTextView.text = "add a description ..."
            AddDescriptionTextView.textColor = UIColor.lightGray
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
extension AddToDoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
