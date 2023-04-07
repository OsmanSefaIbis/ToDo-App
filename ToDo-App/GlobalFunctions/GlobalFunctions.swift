//
//  GlobalFunctions.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit
import CoreData

// MARK: Core Data
let appDelegate = UIApplication.shared.delegate as! AppDelegate

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
    } catch {
        print("Error: Occured in deleteFromCoreData() with \(error) ")
    }
}

public func retrieveFromCoreData(to databaseData: inout [TodoEntity]) {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    do{
        let result = try context.fetch(request)
        databaseData = result
    }catch{
        print("Error: Occured in retrieveFromCoreData() with \(error) ")
    }
}

func listDataInCoreData(){
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    do {
        _ = try context.fetch(fetchRequest)
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
        print("Core Data Dumped")
    } catch {
        fatalError("Core Data dump gone bad ... ")
    }
}

func convertTagStringToSetOfEnumTag(for tagStringSpaced : String) -> Set<EnumTag>{
    let tagsString = tagStringSpaced.replacingOccurrences(of: " ", with: "")
    let tagsArray = tagsString.components(separatedBy: ",")
    let tagsSet: Set<EnumTag> = Set(tagsArray.compactMap { EnumTag(rawValue: $0) })
    return tagsSet
}

func initiateTagFlags(for tagFlagDictionary: inout [String : Bool] ) {
    tagFlagDictionary = [
        EnumTagPressed.workPressedFlag.rawValue : false,
        EnumTagPressed.studyPressedFlag.rawValue : false,
        EnumTagPressed.entertainmentPressedFlag.rawValue : false,
        EnumTagPressed.familyPressedFlag.rawValue : false,
    ]
}

let hapticHeavy = UIImpactFeedbackGenerator(style: .medium)
let hapticMedium = UIImpactFeedbackGenerator(style: .medium)
let hapticSoft = UIImpactFeedbackGenerator(style: .soft)

let headerActive = "Active"
let headerDone = "Done"
let emptyTitlePrompt = "title please ... "
let emptyDescriptionPrompt = "description please ... "
let menuOptionEdit = "Edit"
let menuOptionDelete = "Delete"
let emptyMenuTitle = ""
let someKey = "attributedTitle"

func hapticFeedbackHeavy() {
    hapticHeavy.prepare()
    hapticHeavy.impactOccurred(intensity: 1.0)
}

func hapticFeedbackMedium() {
    hapticMedium.prepare()
    hapticMedium.impactOccurred(intensity: 1.0)
}

func hapticFeedbackSoft() {
    hapticSoft.prepare()
    hapticSoft.impactOccurred(intensity: 1.0)
}

func addConfigureTV(for textViewName: UITextView) {
    textViewName.removePlaceholder()
    textViewName.addPlaceholder("add a description ...")
    textViewName.layer.borderWidth = 0.5
    textViewName.layer.borderColor = UIColor.lightGray.cgColor
    textViewName.layer.cornerRadius = 5.0
    textViewName.autocorrectionType = .no
    textViewName.autocapitalizationType = .sentences
}

func addConfigureTF(for textFieldName: UITextField) {
    textFieldName.layer.borderWidth = 0.5
    textFieldName.layer.borderColor = UIColor.lightGray.cgColor
    textFieldName.layer.cornerRadius = 5.0
    textFieldName.autocorrectionType = .no
    textFieldName.autocapitalizationType = .words
}

func configureButton(for buttonName: UIButton, tag tagName: String) {
    let values = (font :EnumFont.tagIcon.rawValue, cornerRadius: Double(EnumFont.tagCornerRadius.rawValue))
    buttonName.setImage(createTagIcon(tag: tagName, font: values.font), for: .normal)
    buttonName.layer.cornerRadius = values.cornerRadius
}
func configureAddTodoButton(for buttonName: UIButton) {
    let iconFont = UIFont.systemFont(ofSize: CGFloat(EnumFont.addButtonIcon.rawValue),weight: .bold)
    let configuration = UIImage.SymbolConfiguration(font: iconFont)
    let addButtonIcon = UIImage(systemName: EnumIcon.forAddButton.rawValue,
                                withConfiguration: configuration)?
                                .withTintColor(EnumColor.lightGray.getColor(),
                                renderingMode: .alwaysOriginal)
    buttonName.setImage(addButtonIcon, for: .normal)
}

func createTagIcon(tag tagName: String, font FontSize: Int) -> UIImage {
    let tagIconName = EnumIcon.forTag.rawValue
    var tagIcon = UIImage(systemName: tagIconName)
    let iconFont = UIFont.systemFont(ofSize: CGFloat(FontSize))
    let configuration = UIImage.SymbolConfiguration(font: iconFont)
    switch tagName{
        case EnumTag.work.rawValue:
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.work.getColor(), renderingMode: .alwaysOriginal)
        case EnumTag.study.rawValue:
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.study.getColor(), renderingMode: .alwaysOriginal)
        case EnumTag.entertainment.rawValue:
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.entertainment.getColor(), renderingMode: .alwaysOriginal)
        case EnumTag.family.rawValue:
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.family.getColor(), renderingMode: .alwaysOriginal)
    default:
        tagIcon = UIImage(systemName: tagIconName)
    }
    return tagIcon!
}


func strikeThrough(for text: String?) -> (NSMutableAttributedString) {
    guard let text else { return NSMutableAttributedString()}
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedText.length))
    return attributedText
}

func removeStrikeThrough(for text: NSAttributedString?)-> (NSMutableAttributedString) {
    guard let text else { return NSMutableAttributedString()}
    let mutableAttributedText = NSMutableAttributedString(attributedString: text)
    mutableAttributedText.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, mutableAttributedText.length))
    return mutableAttributedText
}

func buttonScaleUpAnimation(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }, completion: { _ in
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = CGAffineTransform.identity
        })
    })
}

func producesMenuOptionTitles() -> (NSAttributedString, NSAttributedString){
    let font = UIFont.systemFont(ofSize: 12)
    let attributes = [NSAttributedString.Key.font: font]
    let editTitle = NSAttributedString(string: menuOptionEdit, attributes: attributes)
    let deleteTitle = NSAttributedString(string: menuOptionDelete, attributes: attributes)
    return (editTitle, deleteTitle)
}
