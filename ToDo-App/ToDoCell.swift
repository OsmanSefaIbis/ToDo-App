//
//  ToDoCell.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    // MARK: UI Components
    @IBOutlet weak var ToDoTitleLabel: UILabel!
    @IBOutlet weak var OptionsToDoButton: UIButton!
    @IBOutlet weak var ToDoDescriptionLabel: UILabel!
    @IBOutlet weak var ToDoTagsLabel: UILabel!
    @IBOutlet weak var ToDoDoneButton: UIButton!

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
    }
    
    @IBAction func OptionsToDoButtonPressed(_ sender: Any) {
        
    }
    @IBAction func DoneButtonPressed(_ sender: Any) {
        
    }
}

struct ToDoCellModel{
    var title: String
    var description: String
}

enum TagEnum: String{
    case work
    case study
    case entertainment
    case family
}
