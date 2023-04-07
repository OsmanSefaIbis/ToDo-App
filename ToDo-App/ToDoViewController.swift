//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var tagButtonWork: UIButton!
    @IBOutlet weak var tagButtonStudy: UIButton!
    @IBOutlet weak var tagButtonEntertainment: UIButton!
    @IBOutlet weak var tagButtonFamily: UIButton!
    @IBOutlet weak var todoTableview: UITableView!
    @IBOutlet weak var addToDoButton: UIButton!
    
    public let cellName = "ToDoCell"
    
    private(set) var databaseData: [TodoEntity] = []
    public var tableviewData: [ToDoCellModel] = []
    public var filteredTableViewData: [ToDoCellModel] = []
    public var doneTableViewData: [ToDoCellModel] = []
    public var filteredDoneTableViewData: [ToDoCellModel] = []
    
    private var isRotating = false
    private var tagSelection: Set<EnumTag> = []
    private var tagFlagDictionary: [String : Bool] = [ : ]
    //private let mockData = MockData()
    
    private var initiateWithSomeData: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableviewSetupUI()
        configureButtonIcons()
        
        //initiateTableViewWithMockData(with: mockData.dataSetDemo)
        //initiateTableViewWithCoreData(with: mockData.dataSetForCoreData)
        
        
        /* IMPORTANT */
        /*
        Before Refactoring, the below 4 line was used for testing the app execution ,
        comment first line to dump core data, vice versa,
        to start adding editing doneing and deleting todos.
        // All of the tracing printouts are left intentionally, maybe for future use.
         */
        
        initiateTableViewWithCoreData(with: [])
        ToDoCellModel.resetId()
        dumpCoreData()
        listDataInCoreData()
        
        initiateTagFlags()
        updateData()
        configureaddToDoButton()
    }

    func initiateTableViewWithMockData(with dataSet: [ToDoCellModel] ) {
        tableviewData = dataSet
    }
    func initiateTableViewWithCoreData(with dataSet: [ToDoCellModel]){
        retrieveFromCoreData()
        var dataFetchedFromCoreData: [ToDoCellModel] = databaseData.map {
            let tagsStringSpaced = $0.todoTags ?? ""
            let tagsString = tagsStringSpaced.replacingOccurrences(of: " ", with: "")
            let tagsArray = tagsString.components(separatedBy: ",")
            let tagsSet: Set<EnumTag> = Set(tagsArray.compactMap { EnumTag(rawValue: $0) })
            return ToDoCellModel(
                title: $0.todoTitle ?? "",
                description: $0.todoDescription ?? "",
                tags: tagsSet,
                doneFlag: $0.todoDoneFlag
            )
        }
        for each in dataFetchedFromCoreData{
            if each.doneFlag{
                doneTableViewData.append(each)
            }else{
                tableviewData.append(each)
            }
        }
    }
    
    public func updateData() {
        if Array(tagSelection).isEmpty{
            filteredTableViewData = tableviewData
            filteredDoneTableViewData = doneTableViewData
        }else{
            filteredTableViewData = tableviewData.filter { element in
                element.tags.contains(where: { Array(tagSelection).contains($0) })
            }
            filteredDoneTableViewData = doneTableViewData.filter { element in
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
            let section = indexPath.section
            switch section{
            case 0:
                vc.configureFields(with: filteredTableViewData[indexPath.row])
            case 1:
                vc.configureFields(with: filteredDoneTableViewData[indexPath.row])
            default:
                break
            }
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
    // MARK: Core Data
    public func saveToCoreData(_ data: ToDoCellModel) {
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "TodoEntity", in: context){
            let todoObject = NSManagedObject(entity: entity, insertInto: context)
            todoObject.setValue(data.id, forKey: "id")
            todoObject.setValue(data.title, forKey: "todoTitle")
            todoObject.setValue(data.description, forKey: "todoDescription")
            let tags = data.tags.map({ $0.rawValue }).joined(separator: ", ")
            todoObject.setValue(tags, forKey: "todoTags")
            todoObject.setValue(data.doneFlag, forKey: "todoDoneFlag")
            do{
                try context.save()
                print(" ˆˆˆˆˆ CoreData: Data saved successfully! ˆˆˆˆˆ \n")
            }catch{
                print("Error: Occured in saveToCoreData() with \(error)")
            }
        }
    }
    
    public func updateDataInCoreData(_ data: ToDoCellModel) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(data.id)")
        do {
            let results = try context.fetch(fetchRequest)
            
            if let todoObject = results.first {
                todoObject.setValue(data.title, forKey: "todoTitle")
                todoObject.setValue(data.description, forKey: "todoDescription")
                let tags = data.tags.map({ $0.rawValue }).joined(separator: ", ")
                todoObject.setValue(tags, forKey: "todoTags")
                todoObject.setValue(data.doneFlag, forKey: "todoDoneFlag")
            }
            try context.save()
            print(" ˆˆˆˆˆ CoreData: Data updated successfully! ˆˆˆˆˆ \n")
            
        } catch {
            print("Error: Occured in updateDataInCoreData() with \(error) ")
        }
    }
    
    public func deleteFromCoreData(with id: Int64){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        do {
            let deleteEntity = try context.fetch(fetchRequest)
            for thisEntity in deleteEntity {
                context.delete(thisEntity)
            }
            try context.save()
            print(" ˆˆˆˆˆ CoreData: Data deleted successfully! ˆˆˆˆˆ \n")
        } catch {
            print("Error: Occured in deleteFromCoreData() with \(error) ")
        }
    }
    
    private func retrieveFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        do{
            let result = try context.fetch(request)
            print(" ˆˆˆˆˆ CoreData - Total data count:  \(result.count) ˆˆˆˆˆ \n")
            self.databaseData = result
        }catch{
            print("Error: Occured in retrieveFromCoreData() with \(error) ")
        }
    }
    func listDataInCoreData(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        do {
            let todoList = try context.fetch(fetchRequest)
            print("****** START")
            for (index, todo) in todoList.enumerated() {
                print("Index: \(index+1) - ID: \(todo.id) - Title: \(todo.todoTitle ?? "") \t\t- DoneFlag: \(todo.todoDoneFlag) \t- Tags: \(todo.todoTags ?? "") \t\t\t\t- Description: \(todo.todoDescription ?? "" )")
            }
            print("****** END \n")
        } catch let error as NSError {
            print("Error: Occured in listDataInCoreData() with \(error) ")
        }
    }
    
    func dumpCoreData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        let persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator

        do {
            try persistentStoreCoordinator.execute(batchDeleteRequest, with: appDelegate.persistentContainer.viewContext)
            print(" ˆˆˆˆˆ Core Data dumped ˆˆˆˆˆ \n")
        } catch {
            fatalError("Core Data dump gone bad ... ")
        }
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



