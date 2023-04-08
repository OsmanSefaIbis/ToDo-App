//
//  CustomCellDelegate.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

extension ToDoViewController: CustomCellDelegate {
    
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    
    func deleteActionPressed(at indexPath: IndexPath) {
        
        let id: Int64
        let section = indexPath.section
        switch section {
            case 0:
                id = filteredActiveTableViewData[indexPath.row].id
                activeTableViewData.removeAll(where: { $0.id == id } )
            case 1:
                id = filteredDoneTableViewData[indexPath.row].id
                doneTableViewData.removeAll(where: { $0.id == id } )
        default:
            return
        }
        deleteFromCoreData(with: id)
        updateData()
    }
    
    func doneButtonPressed(_ cell: ToDoCell) {
        
        var movedObject: ToDoCellModel?
        var destinationIndexPath = IndexPath()
        guard let sourceIndexPath = todoTableview.indexPath(for: cell) else { return }
        
        if let section = cell.indexPath?.section {
            switch section {
                case 0:
                    filteredActiveTableViewData[sourceIndexPath.row].doneFlag.toggle()
                    movedObject = filteredActiveTableViewData[sourceIndexPath.row]
                    destinationIndexPath = IndexPath(row: 0, section: 1)
                    tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
                case 1:
                    filteredDoneTableViewData[sourceIndexPath.row].doneFlag.toggle()
                    movedObject = filteredDoneTableViewData[sourceIndexPath.row]
                    destinationIndexPath = IndexPath(row: activeTableViewData.count, section: 0)
                    tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
            default:
                break
            }
        }
        guard let unWrapMovedObject = movedObject else { return }
        updateDataInCoreData(unWrapMovedObject)
        updateData()
    }
    
}
