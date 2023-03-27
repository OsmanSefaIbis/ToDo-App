//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

protocol ToDoAddedDelegate: AnyObject{
    func didChanged(_ title: String?, _ description: String?, _ tags: Set<TagEnum>?)
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
    
    private var tagSelection: Set<TagEnum> = []
    // Tag Flags
    private var workPressedFlag: Bool = false
    private var studyPressedFlag: Bool = false
    private var entertainmentPressedFlag: Bool = false
    private var familyPressedFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        assignDelegates()
        AddDescriptionTextView.text = "add a description ..."
        AddDescriptionTextView.textColor = .lightGray
    }
    func assignDelegates(){
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
    }
    
    // MARK: Button Actions
    @IBAction func TagButtonWorkPressed(_ sender: Any) {
        workPressedFlag = !workPressedFlag
        if workPressedFlag{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    @IBAction func TagButtonStudyPressed(_ sender: Any) {
        studyPressedFlag = !studyPressedFlag
        if studyPressedFlag{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    @IBAction func TagButtonEntertainmentPressed(_ sender: Any) {
        entertainmentPressedFlag = !entertainmentPressedFlag
        if entertainmentPressedFlag{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    @IBAction func TagButtonFamilyPressed(_ sender: Any) {
        familyPressedFlag = !familyPressedFlag
        if familyPressedFlag{
            tagSelection.insert(.family)
        }else{
            tagSelection.remove(.family)
        }
    }
    
    @IBAction func CancelToDoButtonPressed(_ sender: Any) {
        dismiss(animated: false)
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
        delegate?.didChanged(AddTitleTextField.text, AddDescriptionTextView.text, tagSelection)
        dismiss(animated: false)
    }
}


// MARK: Extensions
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
