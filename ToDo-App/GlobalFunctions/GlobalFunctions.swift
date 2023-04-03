//
//  GlobalFunctions.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

let hapticHeavy = UIImpactFeedbackGenerator(style: .medium)
let hapticMedium = UIImpactFeedbackGenerator(style: .medium)
let hapticSoft = UIImpactFeedbackGenerator(style: .soft)

func hapticFeedbackHeavy() {
    hapticHeavy.prepare()
    hapticHeavy.impactOccurred(intensity: 1.0)
}

func hapticFeedbackMedium() {
    hapticMedium.prepare()
    hapticMedium.impactOccurred(intensity: 1.0)
}

func hapticFeedbackSoft() {
    hapticSoft.prepare()
    hapticSoft.impactOccurred(intensity: 1.0)
}

func addConfigureTV(for textViewName: UITextView) {
    textViewName.addPlaceholder("add a description ...")
    textViewName.layer.borderWidth = 0.5
    textViewName.layer.borderColor = UIColor.lightGray.cgColor
    textViewName.layer.cornerRadius = 5.0
    textViewName.autocorrectionType = .no
    textViewName.autocapitalizationType = .sentences
}

func addConfigureTF(for textFieldName: UITextField) {
    textFieldName.layer.borderWidth = 0.5
    textFieldName.layer.borderColor = UIColor.lightGray.cgColor
    textFieldName.layer.cornerRadius = 5.0
    textFieldName.autocorrectionType = .no
    textFieldName.autocapitalizationType = .words
}

func configureButton(for buttonName: UIButton, tag tagName: String) {
    let values = (font :EnumFont.tagIcon.rawValue, cornerRadius: Double(EnumFont.tagCornerRadius.rawValue))
    buttonName.setImage(createTagIcon(tag: tagName, font: values.font), for: .normal)
    buttonName.layer.cornerRadius = values.cornerRadius
}

func createTagIcon(tag tagName: String, font FontSize: Int) -> UIImage {
    let tagIconName = EnumIcon.forTag.rawValue
    var tagIcon = UIImage(systemName: tagIconName)
    let iconFont = UIFont.systemFont(ofSize: CGFloat(FontSize))
    let configuration = UIImage.SymbolConfiguration(font: iconFont)
    switch tagName{
        case "work":
        tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.work.getColor(), renderingMode: .alwaysOriginal)
        case "study":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.study.getColor(), renderingMode: .alwaysOriginal)
        case "entertainment":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.entertainment.getColor(), renderingMode: .alwaysOriginal)
        case "family":
            tagIcon = UIImage(systemName: tagIconName, withConfiguration: configuration)?.withTintColor(EnumColor.family.getColor(), renderingMode: .alwaysOriginal)
        default:
            tagIcon = UIImage(systemName: tagIconName)
    }
    return tagIcon!
}

func buttonScaleUpAnimation(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }, completion: { _ in
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = CGAffineTransform.identity
        })
    })
}
