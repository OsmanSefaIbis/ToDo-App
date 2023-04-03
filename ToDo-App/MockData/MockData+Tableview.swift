//
//  mockData+Tableview.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 2.04.2023.
//

import Foundation
struct MockData{
    
    let dataSet1: [ToDoCellModel] =
    [
        .init(title: "1", description: "Edit ", tags: [.work]),
        .init(title: "2", description: "Edit.", tags: [.study]),
        .init(title: "3", description: "Edit.", tags: [.work,.study]),
        .init(title: "4", description: "Edit.", tags: [.work, .study, .entertainment]),
        .init(title: "5", description: "Edit.", tags: [ .study, .entertainment]),
        .init(title: "6", description: "Edit.", tags: [ .entertainment]),
        .init(title: "7", description: "Edit.", tags: [.family]),
        .init(title: "8", description: "Edit.", tags: [.work,.family]),
        .init(title: "9", description: "All", tags: [.work, .study, .entertainment,.family]),
    ]
}
