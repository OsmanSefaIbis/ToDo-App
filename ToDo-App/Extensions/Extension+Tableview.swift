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
        headerView.backgroundColor = .systemBackground
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 12))
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font, ]
        
        titleLabel.textColor = EnumColor.lightGray.getColor()
        switch section{
        case 0:
            titleLabel.attributedText = NSAttributedString(string: "Active", attributes: attributes)
        case 1:
            var donetitle = strikeThrough(for: "Done")
            donetitle.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, donetitle.length))
            titleLabel.attributedText = donetitle
        default:
            titleLabel.text = ""
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
            return doneTableViewData.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = self.ToDoTableview.dequeueReusableCell(withIdentifier: cellName) as! ToDoCell
        todoCell.delegate = self
        todoCell.indexPath = indexPath
        todoCell.doneFlag = filteredTableViewData[indexPath.row].doneFlag
        todoCell.configure(with: filteredTableViewData[indexPath.row])
        return todoCell
    }
}
