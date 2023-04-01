//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

protocol ToDoAddedDelegate: AnyObject{
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?)
    func toDoAdded(for todoModel: ToDoCellModel)
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
    
    var editFlag = false
    var editIndexPath = IndexPath()
    
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
        appTitleStrikeThrough()
        AddDescriptionTextView.text = "add a description ..."
        AddDescriptionTextView.textColor = .lightGray
        configureTagButtons()
    }
    func assignDelegates(){
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
    }
    func configureTagButtons(){
        self.TagButtonWork.setImage(createTagIcon(tag: "work", font:12), for: .normal)
        self.TagButtonWork.layer.cornerRadius = 15.0
        self.TagButtonStudy.setImage(createTagIcon(tag: "study", font:12), for: .normal)
        self.TagButtonStudy.layer.cornerRadius = 15.0
        self.TagButtonEntertainment.setImage(createTagIcon(tag: "entertainment", font:12), for: .normal)
        self.TagButtonEntertainment.layer.cornerRadius = 15.0
        self.TagButtonFamily.setImage(createTagIcon(tag: "family", font:12), for: .normal)
        self.TagButtonFamily.layer.cornerRadius = 15.0
    }
    func revertTagButtonBackground(for tagName: String, with flag: Bool){
        let desired = (tagName, true)
        switch desired{
            case ("work",flag):
                TagButtonWork.backgroundColor = UIColor(hex: "#D2CEFF66")
            case ("work",_):
                TagButtonWork.backgroundColor = UIColor.white
            case ("study",flag):
                TagButtonStudy.backgroundColor = UIColor(hex: "#D1E5F788")
            case ("study",_):
                TagButtonStudy.backgroundColor = UIColor.white
            case ("entertainment",flag):
                TagButtonEntertainment.backgroundColor = UIColor(hex: "#FFCECE66")
            case ("entertainment",_):
                TagButtonEntertainment.backgroundColor = UIColor.white
            case ("family",flag):
                TagButtonFamily.backgroundColor = UIColor(hex: "#DAF2D688")
            case ("family",_):
                TagButtonFamily.backgroundColor = UIColor.white
            default:
                break
        }
    }
    func configureFields(with cellModel: ToDoCellModel){
        self.AddTitleTextField.text = cellModel.title
        self.AddDescriptionTextView.text = cellModel.description
        self.tagSelection = cellModel.tags
    }
    func appTitleStrikeThrough(){
        let text = "todo"
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
        let todo: ToDoCellModel = .init(
                title: AddTitleTextField.text!,
                description: AddDescriptionTextView.text,
                tags:self.tagSelection)
        if self.editFlag == true{
            delegate?.editChanged(for: todo, at: self.editIndexPath)
        }else{
            delegate?.toDoAdded(for: todo)
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
