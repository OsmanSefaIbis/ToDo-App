//
//  Extension+Tableview.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(5.0)
    }
}

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTableViewData.count
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
