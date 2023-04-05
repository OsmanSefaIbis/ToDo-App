//
//  ToDoCellModel.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

struct ToDoCellModel{
    static var nextId: Int64 = 1
    let id: Int64
    var title: String
    var description: String
    var tags: Set<EnumTag>
    var doneFlag: Bool = false
    
    init(title: String, description: String, tags: Set<EnumTag>) {
        self.id = ToDoCellModel.nextId
        ToDoCellModel.nextId += 1
        self.title = title
        self.description = description
        self.tags = tags
    }
    init(title: String, description: String, tags: Set<EnumTag>, doneFlag: Bool) {
        self.id = ToDoCellModel.nextId
        ToDoCellModel.nextId += 1
        self.title = title
        self.description = description
        self.tags = tags
        self.doneFlag = doneFlag
    }
    static func resetId(){
        ToDoCellModel.nextId = 1
    }
}
