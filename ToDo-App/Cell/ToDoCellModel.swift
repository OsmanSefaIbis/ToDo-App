//
//  ToDoCellModel.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 3.04.2023.
//

import Foundation

struct ToDoCellModel{
    static var nextId: Int64 = 1 // auto-increments id
    let id: Int64
    var title: String
    var description: String
    var tags: Set<EnumTag>
    var doneFlag: Bool = false
    
    // invoked with newTodo
    init(title: String, description: String, tags: Set<EnumTag>) {
        id = ToDoCellModel.nextId
        ToDoCellModel.nextId += 1
        self.title = title
        self.description = description
        self.tags = tags
    }
    // invoked when mapping coreData data to struct data
    init(title: String, description: String, tags: Set<EnumTag>, doneFlag: Bool) {
        id = ToDoCellModel.nextId
        ToDoCellModel.nextId += 1
        self.title = title
        self.description = description
        self.tags = tags
        self.doneFlag = doneFlag
    }
    // invoked with editedTodo
    init(id: Int64, title: String, description: String, tags: Set<EnumTag>, doneFlag: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.tags = tags
        self.doneFlag = doneFlag
    }
    static func resetId(){
        ToDoCellModel.nextId = 1
    }
}
