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
            let section = indexPath.section
            switch section{
            case 0:
                let editedTodoId = filteredTableViewData[indexPath.row].id
                let editedTodoDoneFlag = filteredTableViewData[indexPath.row].doneFlag
                
                tableviewData.removeAll(where: { $0.id == editedTodoId } )
                editedTodo = .init(id: editedTodoId,
                                   title: editedValues["title"] as! String,
                                   description: editedValues["description"] as! String,
                                   tags: editedValues["tags"] as! Set<EnumTag>,
                                   doneFlag: editedTodoDoneFlag)
                guard let unWrappedEditedTodo = editedTodo else{ return }
                tableviewData.insert(unWrappedEditedTodo, at: 0)
            case 1:
                let editedTodoId = filteredDoneTableViewData[indexPath.row].id
                let editedTodoDoneFlag = filteredDoneTableViewData[indexPath.row].doneFlag
                
                doneTableViewData.removeAll(where: { $0.id == editedTodoId } )
                editedTodo = .init(id: editedTodoId,
                                   title: editedValues["title"] as! String,
                                   description: editedValues["description"] as! String,
                                   tags: editedValues["tags"] as! Set<EnumTag>,
                                   doneFlag: editedTodoDoneFlag)
                guard let unWrappedEditedTodo = editedTodo else{ return }
                doneTableViewData.insert(unWrappedEditedTodo, at: 0)
            default:
                break
            }
            guard let unWrappedEditedTodo = editedTodo else{ return }
            
            print("****************************** editChanged ****************************** ID: \(unWrappedEditedTodo.id) \n")
            listDataInCoreData()
            updateDataInCoreData(unWrappedEditedTodo)
            listDataInCoreData()
            updateData()
        }
    }

    func todoAdded(for todoModel: ToDoCellModel) {
        tableviewData.insert(todoModel, at: 0)
        print("****************************** todoAdded ****************************** ID: \(todoModel.id) \n")
        listDataInCoreData()
        saveToCoreData(todoModel)
        listDataInCoreData()
        updateData()
    }
}
