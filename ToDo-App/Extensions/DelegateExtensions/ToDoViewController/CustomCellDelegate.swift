//
//  CustomCellDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: CustomCellDelegate {
    
    func deleteActionPressed(at indexPath: IndexPath) {
        let section = indexPath.section
        switch section{
        case 0:
            tableviewData.remove(at: indexPath.row)
        case 1:
            doneTableViewData.remove(at: indexPath.row)
        default:
            return
        }
        updateData()
    }
    
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    
    func doneButtonPressed(_ cell: ToDoCell) {
        guard let sourceIndexPath = todoTableview.indexPath(for: cell) else { return }
        var destinationIndexPath = IndexPath()
        var doneCheck: Bool = false
        if let section = cell.indexPath?.section{
            switch section{
            case 0:
                doneCheck = tableviewData[sourceIndexPath.row].doneFlag
            case 1:
                doneCheck = doneTableViewData[sourceIndexPath.row].doneFlag
            default:
                break
            }
        }
        if !doneCheck{
            tableviewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: 0, section: 1)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }else{
            doneTableViewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: tableviewData.count-1, section: 0)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        updateData()
    }
}
