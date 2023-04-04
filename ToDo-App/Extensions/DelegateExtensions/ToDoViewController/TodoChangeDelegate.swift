//
//  TodoChangeDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: TodoChangeDelegate {
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?) {
        var temp = todoModel
        if let indexPath{
            let section = indexPath.section
            switch section{
            case 0:
                tableviewData.remove(at: indexPath.row)
                tableviewData.insert(todoModel, at: indexPath.row)
            case 1:
                temp.doneFlag.toggle()
                doneTableViewData.remove(at: indexPath.row)
                doneTableViewData.insert(temp, at: indexPath.row)
            default:
                break
            }
            updateData()
        }
    }
    func todoAdded(for todoModel: ToDoCellModel) {
        tableviewData.insert(todoModel, at: 0)
        updateData()
    }
}
