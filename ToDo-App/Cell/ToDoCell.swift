//
//  ToDoCell.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit
protocol CustomCellDelegate: AnyObject {
    
    func deleteActionPressed(at indexPath: IndexPath)
    func editActionPressed(at indexPath: IndexPath)
    func doneButtonPressed(_ cell: ToDoCell)
    
}
class ToDoCell: UITableViewCell {

    @IBOutlet weak var ToDoTitleLabel: UILabel!
    @IBOutlet weak var OptionsToDoButton: UIButton!
    @IBOutlet weak var ToDoDescriptionLabel: UILabel!
    @IBOutlet weak var ToDoTagsLabel: UILabel!
    @IBOutlet weak var ToDoDoneButton: UIButton!
    
    var doneFlag: Bool?
    var indexPath: IndexPath?
    weak var delegate: CustomCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonConfigure(color: EnumColor.darkGray.getColor(), font: EnumFont.doneButton.rawValue, imageName: EnumIcon.forDoneUncheck.rawValue)
        OptionsToDoButton.menu = setMenuOptions()
        OptionsToDoButton.showsMenuAsPrimaryAction = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func configure(with model: ToDoCellModel) {
        
        let tagsCellConcat = model.tags.map{ "\($0)" }.joined(separator: ",")
        ToDoTitleLabel.attributedText = spacingAdded(for: model.title, space: 5)
        ToDoDescriptionLabel.attributedText = spacingAdded(for: model.description, space: 5)
        ToDoTagsLabel.attributedText = tagIconConversion(tags: tagsCellConcat)
    }
    
    func spacingAdded(for description: String, space lineSpace: Int) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Double(lineSpace)
        let attributes: [NSAttributedString.Key: Any] = [ .paragraphStyle: paragraphStyle]
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    func tagIconConversion(tags tagString: String) -> NSAttributedString {
        var tagImageArray: [UIImage] = []
        let tagArray = tagString.split(separator: ",")
        let tagAttributedString = NSMutableAttributedString()
        
        for tag in tagArray{
            tagImageArray.append(createTagIcon(tag: String(tag), font: EnumFont.tagIconBig.rawValue))
        }
        for tagImage in tagImageArray {
            let attachment = NSTextAttachment()
            attachment.image = tagImage
            let attachmentString = NSAttributedString(attachment: attachment)
            tagAttributedString.append(attachmentString)
            tagAttributedString.append(NSAttributedString("\t"))
        }
        return NSAttributedString(attributedString: tagAttributedString)
    }
    
    func buttonConfigure(color colorName: UIColor, font fontSize: Int, imageName sfIconName: String) {
        let doneColor = colorName
        let iconFont = UIFont.systemFont(ofSize: CGFloat(fontSize))
        let fontConfiguration = UIImage.SymbolConfiguration(font: iconFont)
        let image = UIImage(systemName: sfIconName, withConfiguration: fontConfiguration)?.withTintColor(doneColor, renderingMode: .alwaysOriginal)
        
        ToDoDoneButton.setImage(image, for: .normal)
        ToDoDoneButton.configuration?.imagePlacement = .trailing
    }
    
    func setMenuOptions() -> UIMenu {
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
    
    func setAllViewsBackgroundColor( _ color: UIColor) {
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
    
    func strikeThroughLabels() {
        ToDoTitleLabel.attributedText = strikeThrough(for: ToDoTitleLabel.text)
        ToDoDescriptionLabel.attributedText = strikeThrough(for: ToDoDescriptionLabel.text)
    }
    
    func unStrikeThroughLabels() {
        ToDoTitleLabel.attributedText = removeStrikeThrough(for: ToDoTitleLabel.attributedText)
        ToDoDescriptionLabel.attributedText = removeStrikeThrough(for: ToDoDescriptionLabel.attributedText)
    }
    
    // MARK: Button Actions
    @IBAction func OptionsToDoButtonPressed(_ sender: Any) {
        hapticFeedbackSoft()
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        hapticFeedbackHeavy()
        buttonScaleUpAnimation(sender)
        delegate?.doneButtonPressed(self)
        guard let done = doneFlag else { return }
        if !done {
            buttonConfigure(color: EnumColor.lightGray.getColor(), font: EnumFont.doneButton.rawValue, imageName: EnumIcon.forDoneCheck.rawValue)
            strikeThroughLabels()
            setAllViewsBackgroundColor(.lightGray)
        }else{
            buttonConfigure(color: EnumColor.darkGray.getColor(), font: EnumFont.doneButton.rawValue , imageName: EnumIcon.forDoneUncheck.rawValue)
            unStrikeThroughLabels()
            setAllViewsBackgroundColor(EnumColor.cornSilk.getColor())
        }
        doneFlag?.toggle()
    }
    
    // MARK: EOF
}




