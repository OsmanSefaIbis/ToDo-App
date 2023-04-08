//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

protocol TodoChangeDelegate: AnyObject{
    
    func editChanged(with editedValues : [String : Any], at indexPath: IndexPath?)
    func todoAdded(for todoModel: ToDoCellModel)
}

class AddToDoViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addDescriptionTextView: UITextView!
    @IBOutlet weak var tagButtonWork: UIButton!
    @IBOutlet weak var tagButtonStudy: UIButton!
    @IBOutlet weak var tagButtonEntertainment: UIButton!
    @IBOutlet weak var tagButtonFamily: UIButton!
    @IBOutlet weak var addToDoButton: UIButton!
    @IBOutlet weak var cancelToDoButton: UIButton!
    
    private let appTitle = "todo"
    private var tagSelection: Set<EnumTag> = []
    private var tagFlagDictionary: [String : Bool] = [ : ]
    
    var editFlag = false
    var editIndexPath = IndexPath()
    weak var delegate: TodoChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        assignDelegates()
        configureUIComponents()
    }
    
    func assignDelegates() {
        addDescriptionTextView.delegate = self
        addTitleTextField.delegate = self
    }
    
    func configureUIComponents(){
        appTitleStrikeThrough()
        configureTextComponents()
        configureTagButtons()
    }
    
    func configureTextComponents() {
        addConfigureTV(for: addDescriptionTextView)
        addConfigureTF(for: addTitleTextField)
    }
    
    func configureTagButtons() {
        configureButton(for: tagButtonWork, tag: EnumTag.work.rawValue)
        configureButton(for: tagButtonStudy, tag: EnumTag.study.rawValue)
        configureButton(for: tagButtonEntertainment, tag: EnumTag.entertainment.rawValue)
        configureButton(for: tagButtonFamily, tag: EnumTag.family.rawValue)
        initiateTagFlags(for: &tagFlagDictionary)
    }
    
    func configureFields(with cellModel: ToDoCellModel) {
        addTitleTextField.text = cellModel.title
        addDescriptionTextView.text = cellModel.description
        tagSelection = cellModel.tags
        transferTagSelectionToButtons(for: tagSelection)
    }
    
    func transferTagSelectionToButtons(for tags: Set<EnumTag>) {
        for tag in tags{
            switch tag{
            case .work:
                tagFlagDictionary[EnumTagPressed.workPressedFlag.rawValue] = true
                revertTagButtonBackground(for: EnumTag.work.rawValue, with: &tagFlagDictionary[EnumTagPressed.workPressedFlag.rawValue]!)
            case .study:
                tagFlagDictionary[EnumTagPressed.studyPressedFlag.rawValue] = true
                revertTagButtonBackground(for: EnumTag.study.rawValue, with: &tagFlagDictionary[EnumTagPressed.studyPressedFlag.rawValue]!)
            case .entertainment:
                tagFlagDictionary[EnumTagPressed.entertainmentPressedFlag.rawValue] = true
                revertTagButtonBackground(for: EnumTag.entertainment.rawValue, with: &tagFlagDictionary[EnumTagPressed.entertainmentPressedFlag.rawValue]!)
            case .family:
                tagFlagDictionary[EnumTagPressed.familyPressedFlag.rawValue] = true
                revertTagButtonBackground(for: EnumTag.family.rawValue, with: &tagFlagDictionary[EnumTagPressed.familyPressedFlag.rawValue]!)
            }
        }
    }
    
    func revertTagButtonBackground(for tagName: String, with flag: inout Bool, toogle: Bool = false) {
        if(toogle){
            flag.toggle()
        }
       let coloredCase = (tagName, true)
        switch coloredCase{
            case (EnumTag.work.rawValue,flag):
                tagButtonWork.backgroundColor = EnumColor.workSoft.getColor()
            case (EnumTag.study.rawValue,flag):
                tagButtonStudy.backgroundColor = EnumColor.studySoft.getColor()
            case (EnumTag.entertainment.rawValue,flag):
                tagButtonEntertainment.backgroundColor = EnumColor.entertainmentSoft.getColor()
            case (EnumTag.family.rawValue,flag):
                tagButtonFamily.backgroundColor = EnumColor.familySoft.getColor()
            case (EnumTag.work.rawValue,_):
                tagButtonWork.backgroundColor = .white
            case (EnumTag.study.rawValue,_):
                tagButtonStudy.backgroundColor = .white
            case (EnumTag.entertainment.rawValue,_):
                tagButtonEntertainment.backgroundColor = .white
            case (EnumTag.family.rawValue,_):
                tagButtonFamily.backgroundColor = .white
        default:
            break
        }
    }
    
    func appTitleStrikeThrough() {
        let text = appTitle
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute( NSAttributedString.Key.strikethroughStyle,
                                    value: 1, range: NSMakeRange(0, attributeString.length))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.appTitleLabel.attributedText = attributeString
        }
    }
    
    // MARK: Button Actions
    @IBAction func tagButtonWorkPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: EnumTag.work.rawValue, with: &tagFlagDictionary[EnumTagPressed.workPressedFlag.rawValue]!, toogle: true)
        if tagFlagDictionary[EnumTagPressed.workPressedFlag.rawValue]!{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    
    @IBAction func tagButtonStudyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: EnumTag.study.rawValue, with: &tagFlagDictionary[EnumTagPressed.studyPressedFlag.rawValue]!, toogle: true)
        if tagFlagDictionary[EnumTagPressed.studyPressedFlag.rawValue]!{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    
    @IBAction func tagButtonEntertainmentPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: EnumTag.entertainment.rawValue, with: &tagFlagDictionary[EnumTagPressed.entertainmentPressedFlag.rawValue]!, toogle: true)
        if tagFlagDictionary[EnumTagPressed.entertainmentPressedFlag.rawValue]!{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    
    @IBAction func tagButtonFamilyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: EnumTag.family.rawValue, with: &tagFlagDictionary[EnumTagPressed.familyPressedFlag.rawValue]!, toogle: true)
        if tagFlagDictionary[EnumTagPressed.familyPressedFlag.rawValue]!{
            tagSelection.insert(.family)
        }else{
            tagSelection.remove(.family)
        }
    }
    
    @IBAction func cancelToDoButtonPressed(_ sender: Any) {
        hapticFeedbackSoft()
        dismiss(animated: false)
    }
    
    @IBAction func addToDoButtonPressed(_ sender: Any) {
        if addTitleTextField.text!.isEmpty {
            addTitleTextField.placeholder = emptyTitlePrompt
            addTitleTextField.shake()
            hapticFeedbackMedium()
        }else if addDescriptionTextView.text.isEmpty {
            addDescriptionTextView.removePlaceholder()
            addDescriptionTextView.addPlaceholder(emptyDescriptionPrompt)
            addDescriptionTextView.shake()
            hapticFeedbackMedium()
        }
        else {
            if editFlag {
                let editedValues: [ String : Any ] = [
                        EnumTodoFields.title.rawValue : addTitleTextField.text! ,
                        EnumTodoFields.description.rawValue : addDescriptionTextView.text!,
                        EnumTodoFields.tags.rawValue : tagSelection
                ]
                delegate?.editChanged(with: editedValues, at: editIndexPath)
            }else {
                let newTodo: ToDoCellModel = .init( title: addTitleTextField.text!,
                                                    description: addDescriptionTextView.text,
                                                    tags: tagSelection)
                delegate?.todoAdded(for: newTodo)
            }
            hapticFeedbackHeavy()
            dismiss(animated: false)
        }
    }
}
