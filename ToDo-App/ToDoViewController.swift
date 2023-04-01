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
//        .init(title: "Work", description: "Edit ", tags: [.work]),
//        .init(title: "Study", description: "Edit.", tags: [.study]),
//        .init(title: "WorkStudy", description: "Edit.", tags: [.work,.study]),
//        .init(title: "WorkStudyEntertainment", description: "Edit.", tags: [.work, .study, .entertainment]),
//        .init(title: "StudyEntertainment", description: "Edit.", tags: [ .study, .entertainment]),
//        .init(title: "Entertainment", description: "Edit.", tags: [ .entertainment]),
//        .init(title: "Family", description: "Edit.", tags: [.family]),
//        .init(title: "WorkFamily", description: "Edit.", tags: [.work,.family]),
//        .init(title: "All", description: "All", tags: [.work, .study, .entertainment,.family]),
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
    private var workPressedFlag: Bool = false
    private var studyPressedFlag: Bool = false
    private var entertainmentPressedFlag: Bool = false
    private var familyPressedFlag: Bool = false
    private var isRotating = false
    // MARK: View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        ToDoTableview.delegate = self
        ToDoTableview.dataSource = self
        self.ToDoTableview.register(.init(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        self.ToDoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        configureButtonIcons()
        updateData()
        configureAddToDoButton()
    }
    func configureAddToDoButton(){
        let workTagColor = UIColor(hex: "#69665CFF")!
        let iconFont = UIFont.systemFont(ofSize: CGFloat(40),weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: iconFont)
        let addButtonIcon = UIImage(systemName: "plus", withConfiguration: configuration)?.withTintColor(workTagColor, renderingMode: .alwaysOriginal)
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
        self.TagButtonWork.setImage(createTagIcon(tag: "work", font:12), for: .normal)
        self.TagButtonWork.layer.cornerRadius = 15.0
        self.TagButtonStudy.setImage(createTagIcon(tag: "study", font:12), for: .normal)
        self.TagButtonStudy.layer.cornerRadius = 15.0
        self.TagButtonEntertainment.setImage(createTagIcon(tag: "entertainment", font:12), for: .normal)
        self.TagButtonEntertainment.layer.cornerRadius = 15.0
        self.TagButtonFamily.setImage(createTagIcon(tag: "family", font:12), for: .normal)
        self.TagButtonFamily.layer.cornerRadius = 15.0
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

// MARK: Extensions
extension ToDoViewController: ToDoAddedDelegate{
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?) {
        if let indexPath{
            let sourceRow = indexPath.row
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
        filteredData = data
        ToDoTableview.reloadData()
    }
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    func doneButtonPressed(_ cell: ToDoCell) {
        guard let sourceIndexPath = ToDoTableview.indexPath(for: cell) else { return }
        let destinationIndexPath = IndexPath(row: (data.count-1), section: 0)
        // invert done flag of the specified data
        let doneCheck = data[sourceIndexPath.row].doneFlag
        data[sourceIndexPath.row].doneFlag = !doneCheck
        // manipulate data
        let itemToMove = data.remove(at: sourceIndexPath.row)
        data.append(itemToMove)
        // manipulate view
        if !doneCheck{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32){ [weak self] in
                self!.ToDoTableview.reloadData()
               //self!.ToDoTableview.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }
        }
    }
}
/* MARK: TableView Related */
extension ToDoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 5
        return cellSpacingHeight
    }
}
extension ToDoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ToDoTableview.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDoCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.doneFlag = data[indexPath.row].doneFlag
        cell.configure(with: filteredData[indexPath.row])
        return cell
    }
}

// MARK: Global Func's
func createTagIcon(tag tagName: String, font FontSize: Int) -> UIImage{
    var tagIcon = UIImage(systemName: "circle.fill")
    // Color hexs
    let workTagColor = UIColor(hex: "#D2CEFFFF")!
    let studyTagColor = UIColor(hex: "#D1E5F7FF")!
    let entertainmentTagColor = UIColor(hex: "#FFCECEFF")!
    let familyTagColor = UIColor(hex: "#DAF2D6FF")!
    // Configure
    let iconFont = UIFont.systemFont(ofSize: CGFloat(FontSize))
    let configuration = UIImage.SymbolConfiguration(font: iconFont)
    switch tagName{
        case "work":
            tagIcon = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withTintColor(workTagColor, renderingMode: .alwaysOriginal)
        case "study":
            tagIcon = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withTintColor(studyTagColor, renderingMode: .alwaysOriginal)
        case "entertainment":
            tagIcon = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withTintColor(entertainmentTagColor, renderingMode: .alwaysOriginal)
        case "family":
            tagIcon = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withTintColor(familyTagColor, renderingMode: .alwaysOriginal)
        default:
            tagIcon = UIImage(systemName: "circle.fill")
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
