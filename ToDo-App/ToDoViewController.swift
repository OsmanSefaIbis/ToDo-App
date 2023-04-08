//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var tagButtonWork: UIButton!
    @IBOutlet weak var tagButtonStudy: UIButton!
    @IBOutlet weak var tagButtonEntertainment: UIButton!
    @IBOutlet weak var tagButtonFamily: UIButton!
    @IBOutlet weak var todoTableview: UITableView!
    @IBOutlet weak var addToDoButton: UIButton!
    
    public let cellName = "ToDoCell"
    public let nextViewController = "AddToDoViewController"
    public let storyBoard = "Main"
    public var activeTableViewData: [ToDoCellModel] = []
    public var doneTableViewData: [ToDoCellModel] = []
    public var filteredActiveTableViewData: [ToDoCellModel] = []
    public var filteredDoneTableViewData: [ToDoCellModel] = []
    public var databaseData: [TodoEntity] = []
    
    private var tagSelection: Set<EnumTag> = []
    private var tagFlagDictionary: [String : Bool] = [ : ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableViewSetup()
        configureButtons()
        initiateTableViewWithCoreData()
        updateData()
    }
    
    func testing(){
        ToDoCellModel.resetId()
        dumpCoreData()
    }
    
    func initiateTableViewWithCoreData() {
        //testing()
        retrieveFromCoreData(to: &databaseData)
        var dataFetchedFromCoreData: [ToDoCellModel] = databaseData.map {
            return ToDoCellModel (
                id: $0.id,
                title: $0.todoTitle ?? "",
                description: $0.todoDescription ?? "",
                tags: convertTagStringToSetOfEnumTag(for: $0.todoTags ?? ""),
                doneFlag: $0.todoDoneFlag
            )
        }
        dataFetchedFromCoreData.sort { $0.id > $1.id }
        for each in dataFetchedFromCoreData {
            if each.doneFlag {
                doneTableViewData.append(each)
            }else {
                activeTableViewData.append(each)
            }
        }
    }

    public func updateData() {
        if Array(tagSelection).isEmpty {
            filteredActiveTableViewData = activeTableViewData
            filteredDoneTableViewData = doneTableViewData
        }else {
            filteredActiveTableViewData = activeTableViewData.filter { element in
                element.tags.contains(where: { Array(tagSelection).contains($0) })
            }
            filteredDoneTableViewData = doneTableViewData.filter { element in
                element.tags.contains(where: { Array(tagSelection).contains($0) })
            }
        }
        todoTableview.reloadData()
    }
    
    func tableViewSetup() {
        todoTableview.delegate = self
        todoTableview.dataSource = self
        todoTableview.register(.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        todoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        todoTableview.sectionIndexMinimumDisplayRowCount = 0
    }
    
    func configureButtons() {
        configureButton(for: tagButtonWork, tag: EnumTag.work.rawValue)
        configureButton(for: tagButtonStudy, tag: EnumTag.study.rawValue)
        configureButton(for: tagButtonEntertainment, tag: EnumTag.entertainment.rawValue)
        configureButton(for: tagButtonFamily, tag: EnumTag.family.rawValue)
        configureAddTodoButton(for: addToDoButton)
        initiateTagFlags(for: &tagFlagDictionary)
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
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: nextViewController) as! AddToDoViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.delegate = self
        self.present(nextVC, animated: false)
        
        if let indexPath, let editFlag{
            nextVC.addDescriptionTextView.removePlaceholder()
            nextVC.editFlag = editFlag
            nextVC.editIndexPath = indexPath
            let section = indexPath.section
            switch section{
            case 0:
                nextVC.configureFields(with: filteredActiveTableViewData[indexPath.row])
            case 1:
                nextVC.configureFields(with: filteredDoneTableViewData[indexPath.row])
            default:
                break
            }
        }
    }
    
    func revertTagButtonBackground(for tagName: String, with flag: Bool) {
    let coloredCase = (tagName, true)
    switch coloredCase {
        case (EnumTag.work.rawValue, flag):
            tagButtonWork.backgroundColor = EnumColor.workSoft.getColor()
        case (EnumTag.study.rawValue, flag):
            tagButtonStudy.backgroundColor = EnumColor.studySoft.getColor()
        case (EnumTag.entertainment.rawValue, flag):
            tagButtonEntertainment.backgroundColor = EnumColor.entertainmentSoft.getColor()
        case (EnumTag.family.rawValue, flag):
            tagButtonFamily.backgroundColor = EnumColor.familySoft.getColor()
        case (EnumTag.work.rawValue, _):
            tagButtonWork.backgroundColor = .white
        case (EnumTag.study.rawValue, _):
            tagButtonStudy.backgroundColor = .white
        case (EnumTag.entertainment.rawValue, _):
            tagButtonEntertainment.backgroundColor = .white
        case (EnumTag.family.rawValue, _):
            tagButtonFamily.backgroundColor = .white
    default:
        break
        }
    }
    
    func buttonRotateNinetyDegree(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.transform = sender.transform.rotated(by: CGFloat.pi/2)
        })
    }
    
    // MARK: Button Actions
    @IBAction func tagWorkButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: EnumTag.work.rawValue,
                               flag: &tagFlagDictionary[EnumTagPressed.workPressedFlag.rawValue]!,
                               tag: .work)
    }
    
    @IBAction func tagStudyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: EnumTag.study.rawValue,
                               flag: &tagFlagDictionary[EnumTagPressed.studyPressedFlag.rawValue]!,
                               tag: .study)
    }
    
    @IBAction func tagEntertainmentButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: EnumTag.entertainment.rawValue,
                               flag: &tagFlagDictionary[EnumTagPressed.entertainmentPressedFlag.rawValue]!,
                               tag: .entertainment)
    }
    
    @IBAction func tagFamilyButtonPressed(_ sender: UIButton) {
        hapticFeedbackMedium()
        buttonScaleUpAnimation(sender)
        tagButtonPressedHelper(for: EnumTag.family.rawValue,
                               flag: &tagFlagDictionary[EnumTagPressed.familyPressedFlag.rawValue]!,
                               tag: .family)
    }
    
    @IBAction func addToDoButtonPressed(_ sender: UIButton) {
        hapticFeedbackHeavy()
        buttonRotateNinetyDegree(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.createAddToDoViewController(at: nil, flag: nil)
        }
    }
}



