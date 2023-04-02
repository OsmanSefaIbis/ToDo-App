//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

protocol ToDoChangeDelegate: AnyObject{
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?)
    func toDoAdded(for todoModel: ToDoCellModel)
}
class AddToDoViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var AddTitleTextField: UITextField!
    @IBOutlet weak var AddDescriptionTextView: UITextView!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var AddToDoButton: UIButton!
    @IBOutlet weak var CancelToDoButton: UIButton!
    
    weak var delegate: ToDoChangeDelegate?
    private var tagSelection: Set<TagEnum> = []
    // Vars
    var editFlag = false
    var editIndexPath = IndexPath()
    let appTitle = "todo"
    // Tag Flags
    private var workPressedFlag = false
    private var studyPressedFlag = false
    private var entertainmentPressedFlag = false
    private var familyPressedFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        assignDelegates()
        appTitleStrikeThrough()
        configureTextViews()
        configureTagButtons()
    }
    func assignDelegates(){
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
    }
    func configureTextViews(){
        AddDescriptionTextView.addPlaceholder("add a description ...")
        AddDescriptionTextView.layer.borderWidth = 0.5
        AddDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        AddDescriptionTextView.layer.cornerRadius = 5.0
        AddDescriptionTextView.autocorrectionType = .no
        AddDescriptionTextView.autocapitalizationType = .sentences
        AddTitleTextField.layer.borderWidth = 0.5
        AddTitleTextField.layer.borderColor = UIColor.lightGray.cgColor
        AddTitleTextField.layer.cornerRadius = 5.0
        AddTitleTextField.autocorrectionType = .no
        AddTitleTextField.autocapitalizationType = .words
    
    }
    func configureTagButtons(){
        TagButtonWork.setImage(createTagIcon(tag: "work", font: tagButtonsIconFontSize), for: .normal)
        TagButtonWork.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonStudy.setImage(createTagIcon(tag: "study", font: tagButtonsIconFontSize), for: .normal)
        TagButtonStudy.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonEntertainment.setImage(createTagIcon(tag: "entertainment", font: tagButtonsIconFontSize), for: .normal)
        TagButtonEntertainment.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonFamily.setImage(createTagIcon(tag: "family", font:tagButtonsIconFontSize), for: .normal)
        TagButtonFamily.layer.cornerRadius = tagButtonsCornerRadius
    }
    func configureFields(with cellModel: ToDoCellModel){
        AddTitleTextField.text = cellModel.title
        AddDescriptionTextView.text = cellModel.description
        tagSelection = cellModel.tags
        transferTagSelectionToButtons(for: tagSelection)
    }
    func transferTagSelectionToButtons(for tags: Set<TagEnum>){
        for tag in tags{
            switch tag{
            case .work:
                revertTagButtonBackground(for: "work", with: true)
                workPressedFlag.toggle()
            case .study:
                revertTagButtonBackground(for: "study", with: true)
                studyPressedFlag.toggle()
            case .entertainment:
                revertTagButtonBackground(for: "entertainment", with: true)
                entertainmentPressedFlag.toggle()
            case .family:
                revertTagButtonBackground(for: "family", with: true)
                familyPressedFlag.toggle()
            }
        }
    }
    func revertTagButtonBackground(for tagName: String, with flag: Bool){
       let coloredCase = (tagName, true)
       switch coloredCase{
           case ("work",flag):
               TagButtonWork.backgroundColor = workTagSoftColor
           case ("work",_):
           TagButtonWork.backgroundColor = .white
           case ("study",flag):
               TagButtonStudy.backgroundColor = studyTagSoftColor
           case ("study",_):
           TagButtonStudy.backgroundColor = .white
           case ("entertainment",flag):
               TagButtonEntertainment.backgroundColor = entertainmentTagSoftColor
           case ("entertainment",_):
           TagButtonEntertainment.backgroundColor = .white
           case ("family",flag):
               TagButtonFamily.backgroundColor = familyTagSoftColor
           case ("family",_):
           TagButtonFamily.backgroundColor = .white
           default:
               break
       }
   }
    func appTitleStrikeThrough(){
        let text = appTitle
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.AppTitleLabel.attributedText = attributeString
        }
    }
    // MARK: Button Actions
    @IBAction func TagButtonWorkPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        workPressedFlag.toggle()
        revertTagButtonBackground(for: "work", with: workPressedFlag)
        if workPressedFlag{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    @IBAction func TagButtonStudyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        studyPressedFlag.toggle()
        revertTagButtonBackground(for: "study", with: studyPressedFlag)
        if studyPressedFlag{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    @IBAction func TagButtonEntertainmentPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        entertainmentPressedFlag.toggle()
        revertTagButtonBackground(for: "entertainment", with: entertainmentPressedFlag)
        if entertainmentPressedFlag{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    @IBAction func TagButtonFamilyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        familyPressedFlag.toggle()
        revertTagButtonBackground(for: "family", with: familyPressedFlag)
        if familyPressedFlag{
            tagSelection.insert(.family)
        }else{
            tagSelection.remove(.family)
        }
    }
    @IBAction func CancelToDoButtonPressed(_ sender: Any) {
        hapticFeedbackSoft()
        dismiss(animated: false)
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
        if AddTitleTextField.text!.isEmpty {
            AddTitleTextField.placeholder = "title please ... "
            AddTitleTextField.shake()
        }else if AddDescriptionTextView.text.isEmpty {
            AddDescriptionTextView.removePlaceholder()
            AddDescriptionTextView.addPlaceholder("description please ... ")
            AddDescriptionTextView.shake()
        }
        else{
            let newTodo: ToDoCellModel = .init( title: AddTitleTextField.text!, description: AddDescriptionTextView.text, tags: tagSelection)
            if editFlag == true{
                delegate?.editChanged(for: newTodo, at: editIndexPath)
            }else{
                delegate?.toDoAdded(for: newTodo)
            }
            hapticFeedbackHeavy()
            dismiss(animated: false)
        }
    }
}
// MARK: Extensions
extension AddToDoViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty{
            textView.removePlaceholder()
        }
    }
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

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 6
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
// placeholderLabel.frame = CGRect(x: 5, y: 5, width: AddDescriptionTextView.frame.width, height: 20)
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
