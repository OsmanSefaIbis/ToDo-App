//
//  Extension+Tableview.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(12)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 12))
        let attributes = configureHeaderAttribute()
        switch section {
            case 0:
            titleLabel.attributedText = NSAttributedString(string: headerActive, attributes: attributes.0)
            case 1:
                let donetitle = strikeThrough(for: headerDone)
            donetitle.addAttribute(NSAttributedString.Key.font, value: attributes.1, range: NSMakeRange(0, donetitle.length))
                titleLabel.attributedText = donetitle
        default:
            titleLabel.text = nil
        }
        titleLabel.textColor = EnumColor.lightGray.getColor()
        headerView.backgroundColor = .systemBackground
        headerView.addSubview(titleLabel)
        return headerView
        }
}

extension ToDoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return filteredActiveTableViewData.count
            case 1:
                return filteredDoneTableViewData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = self.todoTableview.dequeueReusableCell(withIdentifier: cellName) as! ToDoCell
        todoCell.indexPath = indexPath
        todoCell.delegate = self
        switch indexPath.section {
            case 0:
                todoCell.configure(with: filteredActiveTableViewData[indexPath.row])
            case 1:
                todoCell.configure(with: filteredDoneTableViewData[indexPath.row])
        default:
            break
        }
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject: ToDoCellModel
        switch sourceIndexPath.section {
            case 0:
                movedObject = filteredActiveTableViewData[sourceIndexPath.row]
                activeTableViewData.removeAll(where: { $0.id == movedObject.id } )
            case 1:
                movedObject = filteredDoneTableViewData[sourceIndexPath.row]
                doneTableViewData.removeAll(where: { $0.id == movedObject.id } )
        default:
            return
        }
        
        switch destinationIndexPath.section {
            case 0:
            activeTableViewData.insert(movedObject, at: destinationIndexPath.row)
            case 1:
            doneTableViewData.insert(movedObject, at: destinationIndexPath.row)
        default:
            return
        }
    }
}
