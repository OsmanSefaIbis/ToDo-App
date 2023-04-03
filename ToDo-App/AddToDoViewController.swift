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
    
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var AddTitleTextField: UITextField!
    @IBOutlet weak var AddDescriptionTextView: UITextView!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var AddToDoButton: UIButton!
    @IBOutlet weak var CancelToDoButton: UIButton!
    
    private let appTitle = "todo"
    private var tagSelection: Set<EnumTag> = []
    private var tagFlagDictionary: [String : Bool] = [ : ]
    
    var editFlag = false
    var editIndexPath = IndexPath()
    weak var delegate: ToDoChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        assignDelegates()
        appTitleStrikeThrough()
        initiateflags()
        configureTextViews()
        configureTagButtons()
    }
    
    func assignDelegates() {
        AddDescriptionTextView.delegate = self
        AddTitleTextField.delegate = self
    }
    
    func configureTextViews() {
        addConfigureTV(for: AddDescriptionTextView)
        addConfigureTF(for: AddTitleTextField)
    }
    
    func configureTagButtons() {
        configureButton(for: TagButtonWork, tag: "work")
        configureButton(for: TagButtonStudy, tag: "study")
        configureButton(for: TagButtonEntertainment, tag: "entertainment")
        configureButton(for: TagButtonFamily, tag: "family")
    }
    
    func configureFields(with cellModel: ToDoCellModel) {
        AddTitleTextField.text = cellModel.title
        AddDescriptionTextView.text = cellModel.description
        tagSelection = cellModel.tags
        transferTagSelectionToButtons(for: tagSelection)
    }
    
    func transferTagSelectionToButtons(for tags: Set<EnumTag>) {
        for tag in tags{
            switch tag{
            case .work:
                tagFlagDictionary["workFlag"] = true
                revertTagButtonBackground(for: "work", with: &tagFlagDictionary["workFlag"]!, toogle: false)
            case .study:
                tagFlagDictionary["studyFlag"] = true
                revertTagButtonBackground(for: "study", with: &tagFlagDictionary["studyFlag"]!, toogle: false)
            case .entertainment:
                tagFlagDictionary["entertainmentFlag"] = true
                revertTagButtonBackground(for: "entertainment", with: &tagFlagDictionary["entertainmentFlag"]!, toogle: false)
            case .family:
                tagFlagDictionary["familyFlag"] = true
                revertTagButtonBackground(for: "family", with: &tagFlagDictionary["familyFlag"]!, toogle: false)
            }
        }
    }
    
    func revertTagButtonBackground(for tagName: String, with flag: inout Bool, toogle: Bool) {
        if(toogle){
            flag.toggle()
        }
       let coloredCase = (tagName, true)
       switch coloredCase{
           case ("work",flag):
               TagButtonWork.backgroundColor = EnumColor.workSoft.getColor()
           case ("work",_):
           TagButtonWork.backgroundColor = .white
           case ("study",flag):
               TagButtonStudy.backgroundColor = EnumColor.studySoft.getColor()
           case ("study",_):
           TagButtonStudy.backgroundColor = .white
           case ("entertainment",flag):
               TagButtonEntertainment.backgroundColor = EnumColor.entertainmentSoft.getColor()
           case ("entertainment",_):
           TagButtonEntertainment.backgroundColor = .white
           case ("family",flag):
               TagButtonFamily.backgroundColor = EnumColor.familySoft.getColor()
           case ("family",_):
           TagButtonFamily.backgroundColor = .white
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
            self.AppTitleLabel.attributedText = attributeString
        }
    }
    
    func initiateflags() {
        tagFlagDictionary = [
            "workFlag" : false,
            "studyFlag" : false,
            "entertainmentFlag" : false,
            "familyFlag" : false,
        ]
    }
    
    // MARK: Button Actions
    @IBAction func TagButtonWorkPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "work", with: &tagFlagDictionary["workFlag"]!, toogle: true)
        if tagFlagDictionary["workFlag"]!{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    
    @IBAction func TagButtonStudyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "study", with: &tagFlagDictionary["studyFlag"]!, toogle: true)
        if tagFlagDictionary["studyFlag"]!{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    
    @IBAction func TagButtonEntertainmentPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "entertainment", with: &tagFlagDictionary["entertainmentFlag"]!, toogle: true)
        if tagFlagDictionary["entertainmentFlag"]!{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    
    @IBAction func TagButtonFamilyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "family", with: &tagFlagDictionary["familyFlag"]!, toogle: true)
        if tagFlagDictionary["familyFlag"]!{
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
            hapticFeedbackMedium()
        }else if AddDescriptionTextView.text.isEmpty {
            AddDescriptionTextView.removePlaceholder()
            AddDescriptionTextView.addPlaceholder("description please ... ")
            AddDescriptionTextView.shake()
            hapticFeedbackMedium()
        }
        else{
            let newTodo: ToDoCellModel = .init( title: AddTitleTextField.text!,
                                                description: AddDescriptionTextView.text,
                                                tags: tagSelection)
            if !editFlag{
                delegate?.toDoAdded(for: newTodo)
            }else{
                delegate?.editChanged(for: newTodo, at: editIndexPath)
            }
            hapticFeedbackHeavy()
            dismiss(animated: false)
        }
    }
    
    // MARK: EOF
}
