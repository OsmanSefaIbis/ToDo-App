//
//  TodoChangeDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: TodoChangeDelegate {
    func editChanged(with editedValues : [String : Any], at indexPath: IndexPath?) {
        if let indexPath{
            let editedTodoId = tableviewData[indexPath.row].id
            let editedTodoDoneFlag = tableviewData[indexPath.row].doneFlag

            let editedTodo: ToDoCellModel = .init(id: editedTodoId,
                                                  title: editedValues["title"] as! String,
                                                  description: editedValues["description"] as! String,
                                                  tags: editedValues["tags"] as! Set<EnumTag>,
                                                  doneFlag: editedTodoDoneFlag)
            let section = indexPath.section
            switch section{
            case 0:
                tableviewData.remove(at: indexPath.row)
                tableviewData.insert(editedTodo, at: indexPath.row)
                listDataInCoreData()
                updateDataInCoreData(editedTodo)
                listDataInCoreData()
            case 1:
                doneTableViewData.remove(at: indexPath.row)
                doneTableViewData.insert(editedTodo, at: indexPath.row)
                // TODO: Add saveToCoreData() for done case
            default:
                break
            }
            updateData()
        }
    }
    func todoAdded(for todoModel: ToDoCellModel) {
        tableviewData.insert(todoModel, at: 0)
        saveToCoreData(todoModel)
        updateData()
    }
}
