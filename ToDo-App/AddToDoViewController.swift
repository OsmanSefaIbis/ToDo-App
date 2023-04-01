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
        appTitleStrikeThrough()
        configureTextViews()
        configureTagButtons()
    }
    func assignDelegates(){
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
    }
    func configureTextViews(){
        AddDescriptionTextView.text = "add a description ..."
        AddDescriptionTextView.textColor = .lightGray
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
    func configureFields(with cellModel: ToDoCellModel){
        AddTitleTextField.text = cellModel.title
        AddDescriptionTextView.text = cellModel.description
        tagSelection = cellModel.tags
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
        buttonScaleUpAnimation(sender)
        workPressedFlag = !workPressedFlag
        revertTagButtonBackground(for: "work", with: workPressedFlag)
        if workPressedFlag{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    @IBAction func TagButtonStudyPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        studyPressedFlag = !studyPressedFlag
        revertTagButtonBackground(for: "study", with: studyPressedFlag)
        if studyPressedFlag{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    @IBAction func TagButtonEntertainmentPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        entertainmentPressedFlag = !entertainmentPressedFlag
        revertTagButtonBackground(for: "entertainment", with: entertainmentPressedFlag)
        if entertainmentPressedFlag{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    @IBAction func TagButtonFamilyPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        familyPressedFlag = !familyPressedFlag
        revertTagButtonBackground(for: "family", with: familyPressedFlag)
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
        let newTodo: ToDoCellModel = .init( title: AddTitleTextField.text!, description: AddDescriptionTextView.text, tags: tagSelection)
        if editFlag == true{
            delegate?.editChanged(for: newTodo, at: editIndexPath)
        }else{
            delegate?.toDoAdded(for: newTodo)
        }
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
