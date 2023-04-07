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
            tableViewData.removeAll(where: { $0.id == deletedObject.id } )
        case 1:
            deletedObject = filteredDoneTableViewData[indexPath.row]
            doneTableViewData.removeAll(where: { $0.id == deletedObject.id } )
        default:
            return
        }
        print("****************************** deleteActionPressed ****************************** ID: \(deletedObject.id) \tTitle: \(deletedObject.title)\n")
        print("*******BEFORE")
        listDataInCoreData()
        deleteFromCoreData(with: deletedObject.id)
        print("*******AFTER")
        listDataInCoreData()
        updateData()
    }
    
    func editActionPressed(at indexPath: IndexPath) {
        createAddToDoViewController(at: indexPath, flag: true)
    }
    
    func doneButtonPressed(_ cell: ToDoCell) {
        var movedObject: ToDoCellModel?
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
            movedObject = filteredTableViewData[sourceIndexPath.row]
            destinationIndexPath = IndexPath(row: 0, section: 1)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }else{
            filteredDoneTableViewData[sourceIndexPath.row].doneFlag.toggle()
            movedObject = filteredDoneTableViewData[sourceIndexPath.row]
            destinationIndexPath = IndexPath(row: filteredTableViewData.count ,section: 0)
            tableView(todoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        guard let unWrappedMovedObject = movedObject else { return }
        print("******************************  doneButtonPressed ****************************** ID: \(unWrappedMovedObject.id) \tTitle: \(unWrappedMovedObject.title) \n")
        print("*******BEFORE")
        listDataInCoreData()
        updateDataInCoreData(unWrappedMovedObject)
        print("*******AFTER")
        listDataInCoreData()
        updateData()
    }
}
