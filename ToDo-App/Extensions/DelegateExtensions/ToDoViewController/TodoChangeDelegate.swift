//
//  TodoChangeDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: TodoChangeDelegate {
    
    func editChanged(for todoModel: ToDoCellModel, at indexPath: IndexPath?) {
        if let indexPath{
            tableviewData.remove(at: indexPath.row)
            tableviewData.append(todoModel)
            updateData()
        }
    }
    func todoAdded(for todoModel: ToDoCellModel) {
        tableviewData.append(todoModel)
        updateData()
    }
}
