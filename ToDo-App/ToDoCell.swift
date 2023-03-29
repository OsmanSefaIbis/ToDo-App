//
//  ToDoCell.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit
protocol CustomCellDelegate: AnyObject{
    func deleteActionPressed(at indexPath: IndexPath)
    func editActionPressed(at indexPath: IndexPath)
    func doneButtonPressed(_ cell: ToDoCell)
}
class ToDoCell: UITableViewCell {

    // MARK: UI Components
    @IBOutlet weak var ToDoTitleLabel: UILabel!
    @IBOutlet weak var OptionsToDoButton: UIButton!
    @IBOutlet weak var ToDoDescriptionLabel: UILabel!
    @IBOutlet weak var ToDoTagsLabel: UILabel!
    @IBOutlet weak var ToDoDoneButton: UIButton!
    
    var indexPath: IndexPath?
    private var doneFlag: Bool = false
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
            if let indexpath = self.indexPath{
                self.delegate?.editActionPressed(at: indexpath)
            }
        }
        let actionDelete = UIAction(title: "Delete") { _ in
            if let indexpath = self.indexPath{
                self.delegate?.deleteActionPressed(at: indexpath)
            }
        }
        return UIMenu(title: "", children: [actionEdit, actionDelete])
    }
    func setAllViewsBackgroundColor( _ color: UIColor){
        for subview in contentView.subviews {
            setSubviewBackgroundColor(subview, color: color)
        }
    }
    private func setSubviewBackgroundColor(_ subview: UIView, color: UIColor) {
        subview.backgroundColor = color
        for subSubview in subview.subviews {
            setSubviewBackgroundColor(subSubview, color: color)
        }
    }
    func strikeThrough(for text: String?) -> (NSMutableAttributedString){
        guard let text else { return NSMutableAttributedString()}
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    @IBAction func OptionsToDoButtonPressed(_ sender: Any) {
        OptionsToDoButton.menu = setMenuOptions()
        OptionsToDoButton.showsMenuAsPrimaryAction = true
    }
    @IBAction func DoneButtonPressed(_ sender: Any) {
        doneFlag = !doneFlag
        if doneFlag {
            delegate?.doneButtonPressed(self)
            setAllViewsBackgroundColor(.lightGray)
            ToDoTitleLabel.attributedText = strikeThrough(for: ToDoTitleLabel.text)
            ToDoDescriptionLabel.attributedText = strikeThrough(for: ToDoDescriptionLabel.text)
        }else{
            if let attributedText = ToDoTitleLabel.attributedText {
                let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                mutableAttributedText.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, mutableAttributedText.length))
                ToDoTitleLabel.attributedText = mutableAttributedText
            }
            if let attributedText = ToDoDescriptionLabel.attributedText {
                let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                mutableAttributedText.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, mutableAttributedText.length))
                ToDoDescriptionLabel.attributedText = mutableAttributedText
            }
            if let cornSilk = UIColor(hex: "#FFF9DEFF"){
                setAllViewsBackgroundColor(cornSilk)
            }
        }
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


