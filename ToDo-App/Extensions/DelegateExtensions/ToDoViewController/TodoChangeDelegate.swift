//
//  TodoChangeDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: TodoChangeDelegate {
    
    func editChanged(with editedValues : [String : Any], at indexPath: IndexPath?) {
        
        var editedTodo: ToDoCellModel?
        if let indexPath{
            switch indexPath.section {
            case 0:
                let (id,doneFlag) = getFields(for: filteredActiveTableViewData, at: indexPath.row)
                editedTodo = .init(id: id,
                                   title: editedValues[EnumTodoFields.title.rawValue] as! String,
                                   description: editedValues[EnumTodoFields.description.rawValue] as! String,
                                   tags: editedValues[EnumTodoFields.tags.rawValue] as! Set<EnumTag>,
                                   doneFlag: doneFlag)
                
                guard let unWrapEditedTodo = editedTodo else { return }
                activeTableViewData.removeAll(where: { $0.id == id } )
                activeTableViewData.insert(unWrapEditedTodo, at: 0)
            case 1:
                let (id,doneFlag) = getFields(for: filteredDoneTableViewData, at: indexPath.row)
                editedTodo = .init(id: id,
                                   title: editedValues[EnumTodoFields.title.rawValue] as! String,
                                   description: editedValues[EnumTodoFields.description.rawValue] as! String,
                                   tags: editedValues[EnumTodoFields.tags.rawValue] as! Set<EnumTag>,
                                   doneFlag: doneFlag)
                
                guard let unWrapEditedTodo = editedTodo else { return }
                doneTableViewData.removeAll(where: { $0.id == id } )
                doneTableViewData.insert(unWrapEditedTodo, at: 0)
            default:
                break
            }
        guard let unWrapEditedTodo = editedTodo else { return }
        updateDataInCoreData(unWrapEditedTodo)
        updateData()
        }
    }

    func todoAdded(for newTodo: ToDoCellModel) {
        
        activeTableViewData.insert(newTodo, at: 0)
        saveToCoreData(newTodo)
        updateData()
    }
}
