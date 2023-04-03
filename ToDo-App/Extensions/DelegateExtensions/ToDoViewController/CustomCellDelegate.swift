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
        guard let sourceIndexPath = ToDoTableview.indexPath(for: cell) else { return }
        let destinationIndexPath = IndexPath(row: (tableviewData.count-1), section: 0)
        let doneCheck = tableviewData[sourceIndexPath.row].doneFlag
        tableviewData[sourceIndexPath.row].doneFlag.toggle()
        let itemToMove = tableviewData.remove(at: sourceIndexPath.row)
        tableviewData.append(itemToMove)
        if !doneCheck{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32){ [weak self] in
               self!.ToDoTableview.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }
        }
    }
}
