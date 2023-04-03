//
//  ToDoCellModel.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

struct ToDoCellModel{
    var title: String
    var description: String
    var tags: Set<EnumTag>
    var doneFlag: Bool = false
}
