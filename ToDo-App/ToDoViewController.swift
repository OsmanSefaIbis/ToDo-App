//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var tagButtonWork: UIButton!
    @IBOutlet weak var tagButtonStudy: UIButton!
    @IBOutlet weak var tagButtonEntertainment: UIButton!
    @IBOutlet weak var tagButtonFamily: UIButton!
    @IBOutlet weak var todoTableview: UITableView!
    @IBOutlet weak var addToDoButton: UIButton!
    
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
        configureaddToDoButton()
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
        todoTableview.reloadData()
    }
    
    func tableviewSetupUI() {
        todoTableview.delegate = self
        todoTableview.dataSource = self
        todoTableview.register(.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        todoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        todoTableview.sectionIndexMinimumDisplayRowCount = 0
    }
    
    func configureButtonIcons() {
        configureButton(for: tagButtonWork, tag: "work")
        configureButton(for: tagButtonStudy, tag: "study")
        configureButton(for: tagButtonEntertainment, tag: "entertainment")
        configureButton(for: tagButtonFamily, tag: "family")
    }
    
    func configureaddToDoButton() {
        let iconFont = UIFont.systemFont(ofSize: CGFloat(EnumFont.addButtonIcon.rawValue),weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: iconFont)
        let addButtonIcon = UIImage(systemName: EnumIcon.forAddButton.rawValue,
                                    withConfiguration: configuration)?
                                    .withTintColor(EnumColor.lightGray.getColor(),
                                    renderingMode: .alwaysOriginal)
        addToDoButton.setImage(addButtonIcon, for: .normal)
    }
    
    func tagButtonPressedHelper(for tagName: String, flag pressedFlag: inout Bool, tag tagEnum: EnumTag) {
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
            vc.addDescriptionTextView.removePlaceholder()
            vc.editFlag = editFlag
            vc.editIndexPath = indexPath
            vc.configureFields(with: filteredTableViewData[indexPath.row])
        }
    }
    
    func revertTagButtonBackground(for tagName: String, with flag: Bool) {
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
    @IBAction func tagWorkButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: "work", flag: &tagFlagDictionary["workPressedFlag"]!, tag: .work)
    }
    
    @IBAction func tagStudyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: "study", flag: &tagFlagDictionary["studyPressedFlag"]!, tag: .study)
    }
    
    @IBAction func tagEntertainmentButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: "entertainment", flag: &tagFlagDictionary["entertainmentPressedFlag"]!,
                               tag: .entertainment)
    }
    
    @IBAction func tagFamilyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: "family", flag: &tagFlagDictionary["familyPressedFlag"]!, tag: .family)
    }
    
    @IBAction func addToDoButtonPressed(_ sender: UIButton) {
        hapticFeedbackHeavy()
        buttonRotateNinetyDegree(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.createAddToDoViewController(at: nil, flag: nil)
        }
    }
    
    // MARK: EOF
}



