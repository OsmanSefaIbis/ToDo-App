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
        var destinationIndexPath = IndexPath()
        let doneCheck = tableviewData[sourceIndexPath.row].doneFlag
        
        if !doneCheck{
            tableviewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: doneTableViewData.count, section: 1)
            tableView(ToDoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }else{
            doneTableViewData[sourceIndexPath.row].doneFlag.toggle()
            destinationIndexPath = IndexPath(row: tableviewData.count, section: 0)
            tableView(ToDoTableview, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        updateData()
//            let itemToMove = tableviewData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
//            doneTableViewData.append(itemToMove)
//            let destinationIndexPath = IndexPath(row: doneTableViewData.count-1, section: 1)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32){ [weak self] in
//                self!.ToDoTableview.beginUpdates()
//                self!.ToDoTableview.deleteRows(at: [sourceIndexPath], with: .automatic)
//                self!.ToDoTableview.insertRows(at: [destinationIndexPath], with: .automatic)
//                self!.ToDoTableview.endUpdates()
//            }
//        }else{
//            doneTableViewData[sourceIndexPath.row].doneFlag.toggle()
//            let itemToMove = doneTableViewData.remove(at: sourceIndexPath.row)
//            tableviewData.append(itemToMove)
//            let destinationIndexPath = IndexPath(row: tableviewData.count-1, section: 0)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32){ [weak self] in
//               self!.ToDoTableview.moveRow(at: sourceIndexPath, to: destinationIndexPath)
//            }
//        }
    }
}
