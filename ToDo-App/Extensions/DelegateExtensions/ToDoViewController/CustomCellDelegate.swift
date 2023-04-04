//
//  CustomCellDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: CustomCellDelegate {
    
    func deleteActionPressed(at indexPath: IndexPath) {
        tableviewData.remove(at: indexPath.row)
        updateData()
    }
    
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    
    func doneButtonPressed(_ cell: ToDoCell) {
        guard let sourceIndexPath = todoTableview.indexPath(for: cell) else { return }
        var destinationIndexPath = IndexPath()
        let doneCheck = tableviewData[sourceIndexPath.row].doneFlag
        
        if !doneCheck{
            tableviewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: 0, section: 1)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }else{
            doneTableViewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: tableviewData.count, section: 0)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        updateData()
    }
}
