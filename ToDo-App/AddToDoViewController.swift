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
        appTitleStrikeThrough()
        initiateflags()
        configureTextViews()
        configureTagButtons()
    }
    
    func assignDelegates() {
        addDescriptionTextView.delegate = self
        addTitleTextField.delegate = self
    }
    
    func configureTextViews() {
        addConfigureTV(for: addDescriptionTextView)
        addConfigureTF(for: addTitleTextField)
    }
    
    func configureTagButtons() {
        configureButton(for: tagButtonWork, tag: "work")
        configureButton(for: tagButtonStudy, tag: "study")
        configureButton(for: tagButtonEntertainment, tag: "entertainment")
        configureButton(for: tagButtonFamily, tag: "family")
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
               tagButtonWork.backgroundColor = EnumColor.workSoft.getColor()
           case ("work",_):
           tagButtonWork.backgroundColor = .white
           case ("study",flag):
               tagButtonStudy.backgroundColor = EnumColor.studySoft.getColor()
           case ("study",_):
           tagButtonStudy.backgroundColor = .white
           case ("entertainment",flag):
               tagButtonEntertainment.backgroundColor = EnumColor.entertainmentSoft.getColor()
           case ("entertainment",_):
           tagButtonEntertainment.backgroundColor = .white
           case ("family",flag):
               tagButtonFamily.backgroundColor = EnumColor.familySoft.getColor()
           case ("family",_):
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
    
    func initiateflags() {
        tagFlagDictionary = [
            "workFlag" : false,
            "studyFlag" : false,
            "entertainmentFlag" : false,
            "familyFlag" : false,
        ]
    }
    
    // MARK: Button Actions
    @IBAction func tagButtonWorkPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "work", with: &tagFlagDictionary["workFlag"]!, toogle: true)
        if tagFlagDictionary["workFlag"]!{
            tagSelection.insert(.work)
        }else{
            tagSelection.remove(.work)
        }
    }
    
    @IBAction func tagButtonStudyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "study", with: &tagFlagDictionary["studyFlag"]!, toogle: true)
        if tagFlagDictionary["studyFlag"]!{
            tagSelection.insert(.study)
        }else{
            tagSelection.remove(.study)
        }
    }
    
    @IBAction func tagButtonEntertainmentPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "entertainment", with: &tagFlagDictionary["entertainmentFlag"]!, toogle: true)
        if tagFlagDictionary["entertainmentFlag"]!{
            tagSelection.insert(.entertainment)
        }else{
            tagSelection.remove(.entertainment)
        }
    }
    
    @IBAction func tagButtonFamilyPressed(_ sender: UIButton) {
        hapticFeedbackSoft()
        buttonScaleUpAnimation(sender)
        revertTagButtonBackground(for: "family", with: &tagFlagDictionary["familyFlag"]!, toogle: true)
        if tagFlagDictionary["familyFlag"]!{
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
            addTitleTextField.placeholder = "title please ... "
            addTitleTextField.shake()
            hapticFeedbackMedium()
        }else if addDescriptionTextView.text.isEmpty {
            addDescriptionTextView.removePlaceholder()
            addDescriptionTextView.addPlaceholder("description please ... ")
            addDescriptionTextView.shake()
            hapticFeedbackMedium()
        }
        else{
            let editedValues: [ String : Any ] = [
                    "title" : addTitleTextField.text! ,
                    "description" : addDescriptionTextView.text!,
                    "tags" : tagSelection
                ]
            if !editFlag{
                let newTodo: ToDoCellModel = .init( title: addTitleTextField.text!,
                                                    description: addDescriptionTextView.text,
                                                    tags: tagSelection)
                delegate?.todoAdded(for: newTodo)
            }else{
                delegate?.editChanged(with: editedValues, at: editIndexPath)
            }
            hapticFeedbackHeavy()
            dismiss(animated: false)
        }
    }
    
    // MARK: EOF
}
