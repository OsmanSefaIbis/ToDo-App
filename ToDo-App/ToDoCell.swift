//
//  ToDoCell.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit
protocol CustomCellDelegate: AnyObject{
    func deleteActionPressed(as indexPath: IndexPath?)
}
class ToDoCell: UITableViewCell {

    // MARK: UI Components
    @IBOutlet weak var ToDoTitleLabel: UILabel!
    @IBOutlet weak var OptionsToDoButton: UIButton!
    @IBOutlet weak var ToDoDescriptionLabel: UILabel!
    @IBOutlet weak var ToDoTagsLabel: UILabel!
    @IBOutlet weak var ToDoDoneButton: UIButton!
    
    var indexPath: IndexPath?
    weak var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    func configure(with model: ToDoCellModel){
        ToDoTitleLabel.text = model.title
        ToDoDescriptionLabel.text = model.description
        ToDoTagsLabel.text = model.tags.map{ "\($0)" }.joined(separator: ", ")
        
    }
    func setMenuOptions() -> UIMenu{
        let actionEdit = UIAction(title: "Edit") { _ in
            print("action edit pressed")
        }
        let actionDelete = UIAction(title: "Delete") { _ in
            guard let indexPath = self.indexPath else { return }
            guard let tableView = self.superview as? UITableView else { return }
            // TODO: Somehow delete the selected row from the tableview
        }
        return UIMenu(title: "", children: [actionEdit, actionDelete])
    }
    
    @IBAction func OptionsToDoButtonPressed(_ sender: Any) {
        OptionsToDoButton.menu = setMenuOptions()
        OptionsToDoButton.showsMenuAsPrimaryAction = true
        
    }
    @IBAction func DoneButtonPressed(_ sender: Any) {
        
    }
}

// MARK: ToDoCellModel
struct ToDoCellModel{
    var title: String
    var description: String
    var tags: Set<TagEnum>
}

enum TagEnum: String{
    case work
    case study
    case entertainment
    case family
}


