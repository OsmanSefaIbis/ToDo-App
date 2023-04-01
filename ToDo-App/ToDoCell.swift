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
    var doneFlag: Bool?
    weak var delegate: CustomCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonConfigure(color: darkGrayColor, font: doneButtonFont, imageName: iconDoneUncheck)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    func configure(with model: ToDoCellModel){
        let tagsCellConcat = model.tags.map{ "\($0)" }.joined(separator: ",")
        ToDoTitleLabel.text = model.title
        ToDoDescriptionLabel.text = model.description
        ToDoTagsLabel.attributedText = tagIconConversion(tags: tagsCellConcat)
    }
    func tagIconConversion(tags tagString: String) -> NSAttributedString{
        // Compositon
        var tagImageArray: [UIImage] = []
        let tagArray = tagString.split(separator: ",")
        for tag in tagArray{
            tagImageArray.append(createTagIcon(tag: String(tag), font: tagButtonsIconFontBigSize))
        }
        // Loop through the array of images and add a text attachment for each image
        let tagAttributedString = NSMutableAttributedString()
        for tagImage in tagImageArray {
            let attachment = NSTextAttachment()
            attachment.image = tagImage
            let attachmentString = NSAttributedString(attachment: attachment)
            tagAttributedString.append(attachmentString)
            tagAttributedString.append(NSAttributedString("\t"))
        }
        return NSAttributedString(attributedString: tagAttributedString)
    }
    func buttonConfigure(color colorName: UIColor, font fontSize: Int, imageName sfIconName: String){
        let doneColor = colorName
        let iconFont = UIFont.systemFont(ofSize: CGFloat(fontSize))
        let fontConfiguration = UIImage.SymbolConfiguration(font: iconFont)
        let image = UIImage(systemName: sfIconName, withConfiguration: fontConfiguration)?.withTintColor(doneColor, renderingMode: .alwaysOriginal)
        ToDoDoneButton.setImage(image, for: .normal)
        ToDoDoneButton.configuration?.imagePlacement = .trailing
    }
    func setMenuOptions() -> UIMenu{
        let font = UIFont.systemFont(ofSize: 12)
        let attributes = [NSAttributedString.Key.font: font]
        let editTitle = NSAttributedString(string: "Edit", attributes: attributes)
        let deleteTitle = NSAttributedString(string: "Delete", attributes: attributes)
        
        let actionEdit = UIAction(title: "Edit") { _ in
            if let indexpath = self.indexPath{
                self.delegate?.editActionPressed(at: indexpath)
            }
        }
        actionEdit.setValue(editTitle, forKey: "attributedTitle")
        
        let actionDelete = UIAction(title: "Delete") { _ in
            if let indexpath = self.indexPath{
                self.delegate?.deleteActionPressed(at: indexpath)
            }
        }
        actionDelete.setValue(deleteTitle, forKey: "attributedTitle")
        let menu = UIMenu(title: "", children: [actionEdit, actionDelete])
        menu.preferredElementSize = .small
        return menu
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
    func removeStrikeThrough(for text: NSAttributedString?)-> (NSMutableAttributedString){
        guard let text else { return NSMutableAttributedString()}
        let mutableAttributedText = NSMutableAttributedString(attributedString: text)
        mutableAttributedText.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, mutableAttributedText.length))
        return mutableAttributedText
    }
    func strikeThroughLabels(){
        ToDoTitleLabel.attributedText = strikeThrough(for: ToDoTitleLabel.text)
        ToDoDescriptionLabel.attributedText = strikeThrough(for: ToDoDescriptionLabel.text)
    }
    func unStrikeThroughLabels(){
        ToDoTitleLabel.attributedText = removeStrikeThrough(for: ToDoTitleLabel.attributedText)
        ToDoDescriptionLabel.attributedText = removeStrikeThrough(for: ToDoDescriptionLabel.attributedText)
    }
    // MARK: Button Actions
    @IBAction func OptionsToDoButtonPressed(_ sender: Any) {
        OptionsToDoButton.menu = setMenuOptions()
        OptionsToDoButton.showsMenuAsPrimaryAction = true
    }
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        buttonScaleUpAnimation(sender)
        delegate?.doneButtonPressed(self)
        guard let done = doneFlag else { return }
        if !done {
            buttonConfigure(color: lightGrayColor, font: doneButtonFont, imageName: iconDoneCheck)
            strikeThroughLabels()
            setAllViewsBackgroundColor(.lightGray)
        }else{
            buttonConfigure(color: darkGrayColor, font: doneButtonFont , imageName: iconDoneUncheck)
            unStrikeThroughLabels()
            setAllViewsBackgroundColor(cornSilkColor)
        }
        doneFlag = !done
    }
}

// MARK: ToDo Cell Model
struct ToDoCellModel{
    var title: String
    var description: String
    var tags: Set<TagEnum>
    var doneFlag: Bool = false
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


