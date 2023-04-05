//
//  ToDoCellModel.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

struct ToDoCellModel{
    let id: UUID
    var title: String
    var description: String
    var tags: Set<EnumTag>
    var doneFlag: Bool = false
    
    init(title: String, description: String, tags: Set<EnumTag>) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.tags = tags
    }
}
