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
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font]
        titleLabel.textColor = EnumColor.lightGray.getColor()
        headerView.backgroundColor = .systemBackground
        
        switch section{
            case 0:
                titleLabel.attributedText = NSAttributedString(string: headerActive, attributes: attributes)
            case 1:
                let donetitle = strikeThrough(for: headerDone)
                donetitle.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, donetitle.length))
                titleLabel.attributedText = donetitle
        default:
            titleLabel.text = nil
        }
        headerView.addSubview(titleLabel)
        return headerView
        }
}

extension ToDoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0:
                return filteredTableViewData.count
            case 1:
                return filteredDoneTableViewData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = self.todoTableview.dequeueReusableCell(withIdentifier: cellName) as! ToDoCell
        todoCell.delegate = self
        todoCell.indexPath = indexPath
        let cellSection = indexPath.section
        switch cellSection{
            case 0:
                todoCell.configure(with: filteredTableViewData[indexPath.row])
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
                movedObject = filteredTableViewData[sourceIndexPath.row]
                tableViewData.removeAll(where: { $0.id == movedObject.id } )
            case 1:
                movedObject = filteredDoneTableViewData[sourceIndexPath.row]
                doneTableViewData.removeAll(where: { $0.id == movedObject.id } )
        default:
            return
        }
        
        switch destinationIndexPath.section {
            case 0:
                tableViewData.append(movedObject)
            case 1:
                doneTableViewData.insert(movedObject, at: 0)
        default:
            return
        }
    }
}
