//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    // MARK: UI Components
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var ToDoTableview: UITableView!
    @IBOutlet weak var AddToDoButton: UIButton!
    
    // MARK: Mock Data
    var data: [ToDoCellModel] =
    [
        .init(title: "1", description: "Edit ", tags: [.work]),
        .init(title: "2", description: "Edit.", tags: [.study]),
        .init(title: "3", description: "Edit.", tags: [.work,.study]),
        .init(title: "4", description: "Edit.", tags: [.work, .study, .entertainment]),
        .init(title: "5", description: "Edit.", tags: [ .study, .entertainment]),
        .init(title: "6", description: "Edit.", tags: [ .entertainment]),
        .init(title: "7", description: "Edit.", tags: [.family]),
        .init(title: "8", description: "Edit.", tags: [.work,.family]),
        .init(title: "9", description: "All", tags: [.work, .study, .entertainment,.family]),
    ]
    var filteredData: [ToDoCellModel] = []
    private var tagSelection: Set<TagEnum> = []
    // Tag Flags
    private var workPressedFlag = false
    private var studyPressedFlag = false
    private var entertainmentPressedFlag = false
    private var familyPressedFlag = false
    private var isRotating = false
    
    // MARK: View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        tableviewSetupUI()
        configureButtonIcons()
        updateData()
        configureAddToDoButton()
    }
    func tableviewSetupUI(){
        ToDoTableview.delegate = self
        ToDoTableview.dataSource = self
        self.ToDoTableview.register(.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        self.ToDoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
    }
    func configureAddToDoButton(){
        let iconFont = UIFont.systemFont(ofSize: CGFloat(addButtonIconFontSize),weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: iconFont)
        let addButtonIcon = UIImage(systemName: addButtonIconName, withConfiguration: configuration)?.withTintColor(addButtonColor, renderingMode: .alwaysOriginal)
        AddToDoButton.setImage(addButtonIcon, for: .normal)
    }
    func TagButtonPressedHelper(for tagName: String, flag pressedFlag: inout Bool, tag tagEnum: TagEnum){
        pressedFlag = !pressedFlag
        revertTagButtonBackground(for: tagName, with: pressedFlag)
        if pressedFlag{
            tagSelection.insert(tagEnum)
        }else{
            tagSelection.remove(tagEnum)
        }
        updateData()
    }
    func updateData(){
        if Array(tagSelection).isEmpty{
            filteredData = data
        }else{
            filteredData = data.filter { element in
                element.tags.contains(where: { Array(tagSelection).contains($0) })
            }
        }
        ToDoTableview.reloadData()
    }
    func revertTagButtonBackground(for tagName: String, with flag: Bool){
        let desired = (tagName, true)
        switch desired{
            case ("work",flag):
                TagButtonWork.backgroundColor = workTagSoftColor
            case ("work",_):
                TagButtonWork.backgroundColor = UIColor.white
            case ("study",flag):
                TagButtonStudy.backgroundColor = studyTagSoftColor
            case ("study",_):
                TagButtonStudy.backgroundColor = UIColor.white
            case ("entertainment",flag):
                TagButtonEntertainment.backgroundColor = entertainmentTagSoftColor
            case ("entertainment",_):
                TagButtonEntertainment.backgroundColor = UIColor.white
            case ("family",flag):
                TagButtonFamily.backgroundColor = familyTagSoftColor
            case ("family",_):
                TagButtonFamily.backgroundColor = UIColor.white
            default:
                break
        }
    }
    func createAddToDoViewController(at indexPath: IndexPath?, flag editFlag: Bool?){
        let nextSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = nextSB.instantiateViewController(withIdentifier: "AddToDoViewController") as! AddToDoViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: false)
        
        if let indexPath, let editFlag{
            vc.AddToDoButton.setTitle("Edit", for: .normal)
            vc.editFlag = editFlag
            vc.configureFields(with: filteredData[indexPath.row])
            vc.editIndexPath = indexPath
        }
    }
    func configureButtonIcons(){
        TagButtonWork.setImage(createTagIcon(tag: "work", font: tagButtonsIconFontSize), for: .normal)
        TagButtonWork.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonStudy.setImage(createTagIcon(tag: "study", font: tagButtonsIconFontSize), for: .normal)
        TagButtonStudy.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonEntertainment.setImage(createTagIcon(tag: "entertainment", font: tagButtonsIconFontSize), for: .normal)
        TagButtonEntertainment.layer.cornerRadius = tagButtonsCornerRadius
        TagButtonFamily.setImage(createTagIcon(tag: "family", font: tagButtonsIconFontSize), for: .normal)
        TagButtonFamily.layer.cornerRadius = tagButtonsCornerRadius
    }
    func buttonRotateNinetyDegree(_ sender: UIButton){
        if !isRotating {
                isRotating = true
                UIView.animate(withDuration: 0.5, animations: {
                    sender.transform = sender.transform.rotated(by: CGFloat.pi/2)
                }, completion: { _ in
                    self.isRotating = false
                })
            }
    }
    // MARK: Button Actions
    @IBAction func TagWorkButtonPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "work", flag: &workPressedFlag, tag: .work)
    }
    @IBAction func TagStudyButtonPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "study", flag: &studyPressedFlag, tag: .study)
    }
    @IBAction func TagEntertainmentButtonPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "entertainment", flag: &entertainmentPressedFlag, tag: .entertainment)
    }
    @IBAction func TagFamilyButtonPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        TagButtonPressedHelper(for: "family", flag: &familyPressedFlag, tag: .family)
    }
    @IBAction func AddToDoButtonPressed(_ sender: UIButton) {
        buttonRotateNinetyDegree(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.createAddToDoViewController(at: nil, flag: nil)
        }
    }
}
// MARK: Delegate Extensions
extension ToDoViewController: ToDoChangeDelegate{
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?) {
        if let indexPath{
            data.remove(at: indexPath.row)
            data.append(todoModel)
            updateData()
        }
    }
    func toDoAdded(for todoModel: ToDoCellModel) {
        data.append(todoModel)
        updateData()
    }
}
extension ToDoViewController: CustomCellDelegate{
    func deleteActionPressed(at indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        updateData()
    }
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    func doneButtonPressed(_ cell: ToDoCell) {
        guard let sourceIndexPath = ToDoTableview.indexPath(for: cell) else { return }
        let destinationIndexPath = IndexPath(row: (data.count-1), section: 0)
        let doneCheck = data[sourceIndexPath.row].doneFlag
        data[sourceIndexPath.row].doneFlag = !doneCheck
        let itemToMove = data.remove(at: sourceIndexPath.row)
        data.append(itemToMove)
        if !doneCheck{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32){ [weak self] in
               self!.ToDoTableview.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }
        }
    }
}
/* MARK: TableView Extension */
extension ToDoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(5.0)
    }
}
extension ToDoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = self.ToDoTableview.dequeueReusableCell(withIdentifier: cellName) as! ToDoCell
        todoCell.delegate = self
        todoCell.indexPath = indexPath
        todoCell.doneFlag = filteredData[indexPath.row].doneFlag
        todoCell.configure(with: filteredData[indexPath.row])
        return todoCell
    }
}

// MARK: Global's

/* Funcs */
func createTagIcon(tag tagName: String, font FontSize: Int) -> UIImage{
    var tagIcon = UIImage(systemName: tagIconName)
    let iconFont = UIFont.systemFont(ofSize: CGFloat(FontSize))
    let configuration = UIImage.SymbolConfiguration(font: iconFont)
    switch tagName{
        case "work":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(workTagColor, renderingMode: .alwaysOriginal)
        case "study":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(studyTagColor, renderingMode: .alwaysOriginal)
        case "entertainment":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(entertainmentTagColor, renderingMode: .alwaysOriginal)
        case "family":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(familyTagColor, renderingMode: .alwaysOriginal)
        default:
            tagIcon = UIImage(systemName: tagIconName)
    }
    return tagIcon!
}

func buttonScaleUpAnimation(_ sender: UIButton){
    UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }, completion: { _ in
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = CGAffineTransform.identity
        })
    })
}
/* Vars */
let tagButtonsCornerRadius = 15.0
let tagButtonsIconFontSize = 12
let tagButtonsIconFontBigSize = 18
let addButtonIconFontSize = 40
let doneButtonFont = 10
let cellName = "ToDoCell"
let addButtonIconName = "plus"
let tagIconName = "circle.fill"
let iconDoneCheck = "checkmark.square.fill"
let iconDoneUncheck = "square.fill"
let workTagColor = UIColor(hex: "#D2CEFFFF")!
let workTagSoftColor = UIColor(hex: "#D2CEFF66")!
let studyTagColor = UIColor(hex: "#D1E5F7FF")!
let studyTagSoftColor = UIColor(hex: "#D1E5F788")!
let entertainmentTagColor = UIColor(hex: "#FFCECEFF")!
let entertainmentTagSoftColor = UIColor(hex: "#FFCECE66")!
let familyTagColor = UIColor(hex: "#DAF2D6FF")!
let familyTagSoftColor = UIColor(hex: "#DAF2D688")!
let addButtonColor = UIColor(hex: "#69665CFF")!
let lightGrayColor = UIColor(hex: "#69665CFF")!
let darkGrayColor = UIColor(hex: "#B2AFA1FF")!
let cornSilkColor = UIColor(hex: "#FFF9DEFF")!
