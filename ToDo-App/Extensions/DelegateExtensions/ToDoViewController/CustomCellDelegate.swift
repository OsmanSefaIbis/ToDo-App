//
//  CustomCellDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: CustomCellDelegate {
    
    func deleteActionPressed(at indexPath: IndexPath) {
        let deletedObject: ToDoCellModel
        let section = indexPath.section
        switch section{
        case 0:
            deletedObject = filteredTableViewData[indexPath.row]
            tableviewData.removeAll(where: { $0.id == deletedObject.id
            } )
        case 1:
            deletedObject = filteredDoneTableViewData[indexPath.row]
            doneTableViewData.removeAll(where: { $0.id == deletedObject.id } )
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
                doneCheck = filteredTableViewData[sourceIndexPath.row].doneFlag
            case 1:
                doneCheck = filteredDoneTableViewData[sourceIndexPath.row].doneFlag
            default:
                break
            }
        }
        if !doneCheck{
            filteredTableViewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: 0, section: 1)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }else{
            filteredDoneTableViewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: tableviewData.count-1, section: 0)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        updateData()
    }
}
