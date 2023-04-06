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
                let editedTodoId = tableviewData[indexPath.row].id
                let editedTodoDoneFlag = tableviewData[indexPath.row].doneFlag

                editedTodo = .init(id: editedTodoId,
                                   title: editedValues["title"] as! String,
                                   description: editedValues["description"] as! String,
                                   tags: editedValues["tags"] as! Set<EnumTag>,
                                   doneFlag: editedTodoDoneFlag)
                guard let unWrappedEditedTodo = editedTodo else{ return }
                tableviewData.remove(at: indexPath.row)
                tableviewData.insert(unWrappedEditedTodo, at: indexPath.row)
            case 1:
                let editedTodoId = doneTableViewData[indexPath.row].id
                let editedTodoDoneFlag = doneTableViewData[indexPath.row].doneFlag

                editedTodo = .init(id: editedTodoId,
                                   title: editedValues["title"] as! String,
                                   description: editedValues["description"] as! String,
                                   tags: editedValues["tags"] as! Set<EnumTag>,
                                   doneFlag: editedTodoDoneFlag)
                guard let unWrappedEditedTodo = editedTodo else{ return }
                doneTableViewData.remove(at: indexPath.row)
                doneTableViewData.insert(unWrappedEditedTodo, at: indexPath.row)
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
