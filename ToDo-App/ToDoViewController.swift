//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var ToDoTableview: UITableView!
    @IBOutlet weak var AddToDoButton: UIButton!
    
    public let cellName = "ToDoCell"
    public var tableviewData: [ToDoCellModel] = []
    public var filteredTableViewData: [ToDoCellModel] = []
    public var doneTableViewData: [ToDoCellModel] = []
    
    private var isRotating = false
    private var tagSelection: Set<EnumTag> = []
    private var tagFlagDictionary: [String : Bool] = [ : ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableviewSetupUI()
        configureButtonIcons()
        initiateTableViewWithMockData()
        initiateTagFlags()
        updateData()
        configureAddToDoButton()
    }

    func initiateTableViewWithMockData() {
        let mockData = MockData()
        tableviewData = mockData.dataSet1
    }
    
    public func updateData() {
        if Array(tagSelection).isEmpty{
            filteredTableViewData = tableviewData
        }else{
            filteredTableViewData = tableviewData.filter { element in
                element.tags.contains(where: { Array(tagSelection).contains($0) })
            }
        }
        ToDoTableview.reloadData()
    }
    
    func tableviewSetupUI() {
        ToDoTableview.delegate = self
        ToDoTableview.dataSource = self
        ToDoTableview.register(.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        ToDoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        ToDoTableview.sectionIndexMinimumDisplayRowCount = 0
    }
    
    func configureButtonIcons() {
        configureButton(for: TagButtonWork, tag: "work")
        configureButton(for: TagButtonStudy, tag: "study")
        configureButton(for: TagButtonEntertainment, tag: "entertainment")
        configureButton(for: TagButtonFamily, tag: "family")
    }
    
    func configureAddToDoButton() {
        let iconFont = UIFont.systemFont(ofSize: CGFloat(EnumFont.addButtonIcon.rawValue),weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: iconFont)
        let addButtonIcon = UIImage(systemName: EnumIcon.forAddButton.rawValue,
                                    withConfiguration: configuration)?
                                    .withTintColor(EnumColor.lightGray.getColor(),
                                    renderingMode: .alwaysOriginal)
        AddToDoButton.setImage(addButtonIcon, for: .normal)
    }
    
    func TagButtonPressedHelper(for tagName: String, flag pressedFlag: inout Bool, tag tagEnum: EnumTag) {
        pressedFlag.toggle()
        revertTagButtonBackground(for: tagName, with: pressedFlag)
        if pressedFlag{
            tagSelection.insert(tagEnum)
        }else{
            tagSelection.remove(tagEnum)
        }
        updateData()
    }
    
    func createAddToDoViewController(at indexPath: IndexPath?, flag editFlag: Bool?) {
        let nextSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = nextSB.instantiateViewController(withIdentifier:
                                                    "AddToDoViewController") as! AddToDoViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: false)
        
        if let indexPath, let editFlag{
            vc.AddDescriptionTextView.removePlaceholder()
            vc.editFlag = editFlag
            vc.editIndexPath = indexPath
            vc.configureFields(with: filteredTableViewData[indexPath.row])
        }
    }
    
    func revertTagButtonBackground(for tagName: String, with flag: Bool) {
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
    
    func buttonRotateNinetyDegree(_ sender: UIButton) {
        if !isRotating {
                isRotating = true
                UIView.animate(withDuration: 0.5, animations: {
                    sender.transform = sender.transform.rotated(by: CGFloat.pi/2)
                }, completion: { _ in
                    self.isRotating = false
                })
            }
    }
    
    func initiateTagFlags() {
        tagFlagDictionary = [
            "workPressedFlag" : false,
            "studyPressedFlag" : false,
            "entertainmentPressedFlag" : false,
            "familyPressedFlag" : false,
        ]
    }
    
    // MARK: Button Actions
    @IBAction func TagWorkButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "work", flag: &tagFlagDictionary["workPressedFlag"]!, tag: .work)
    }
    
    @IBAction func TagStudyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "study", flag: &tagFlagDictionary["studyPressedFlag"]!, tag: .study)
    }
    
    @IBAction func TagEntertainmentButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "entertainment", flag: &tagFlagDictionary["entertainmentPressedFlag"]!,
                               tag: .entertainment)
    }
    
    @IBAction func TagFamilyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "family", flag: &tagFlagDictionary["familyPressedFlag"]!, tag: .family)
    }
    
    @IBAction func AddToDoButtonPressed(_ sender: UIButton) {
        hapticFeedbackHeavy()
        buttonRotateNinetyDegree(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.createAddToDoViewController(at: nil, flag: nil)
        }
    }
    
    // MARK: EOF
}



