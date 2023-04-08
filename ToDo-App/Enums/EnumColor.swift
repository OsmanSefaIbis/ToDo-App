//
//  Enum+Color.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import UIKit

enum EnumColor: String{
    
    case work = "#D2CEFFFF"
    case workSoft = "#D2CEFF66"
    case study = "#D1E5F7FF"
    case studySoft = "#D1E5F788"
    case entertainment = "#FFCECEFF"
    case entertainmentSoft = "#FFCECE66"
    case family = "#DAF2D6FF"
    case familySoft = "#DAF2D688"
    case lightGray = "#69665CFF"
    case darkGray = "#B2AFA1FF"
    case cornSilk = "#FFF9DEFF"
    
    func getColor() -> UIColor{
        var color = UIColor()
        switch self{
            case .work:
                color = UIColor(hex: self.rawValue)!
            case .workSoft:
                color = UIColor(hex: self.rawValue)!
            case .study:
                color = UIColor(hex: self.rawValue)!
            case .studySoft:
                color = UIColor(hex: self.rawValue)!
            case .entertainment:
                color = UIColor(hex: self.rawValue)!
            case .entertainmentSoft:
                color = UIColor(hex: self.rawValue)!
            case .family:
                color = UIColor(hex: self.rawValue)!
            case .familySoft:
                color = UIColor(hex: self.rawValue)!
            case .lightGray:
                color = UIColor(hex: self.rawValue)!
            case .darkGray:
                color = UIColor(hex: self.rawValue)!
            case .cornSilk:
                color = UIColor(hex: self.rawValue)!
            }
        return color
    }
}
