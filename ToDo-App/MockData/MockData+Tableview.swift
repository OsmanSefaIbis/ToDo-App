//
//  mockData+Tableview.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 2.04.2023.
//

struct MockData {
    // Use for demo
    let dataSetDemo: [ToDoCellModel] =
    [
        .init(title: "Apply for IOS jobs", description: "Edit your CV, linkedin. Scout for network. Do learning projects. Do case study examples from web or suggestions. Revisit your learnings.", tags: [.work]),
        .init(title: "Holiday Plan", description: "Select a non-visa country, find cheap accommodation, buy tickets, ask friends to join, plan travel route and locations.", tags: [.entertainment]),
        .init(title: "Organize a family party", description: "Reserve the occasion place. Buy groceries and other stuff related with the party. Invite family members and additional relatives. Arrange a party mix. Buy Drinks !!!", tags: [.family, .entertainment]),
        .init(title: "Finish the mockups of todo app", description: "Learn Figma, imitate the UI design accordingly.", tags: [.study]),
    ]
}
