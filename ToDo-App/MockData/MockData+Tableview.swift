//
//  mockData+Tableview.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 2.04.2023.
//

import Foundation
struct MockData{
    
    let dataSetDemo: [ToDoCellModel] =
    [
        .init(title: "Apply for IOS jobs", description: "Edit your CV, linkedin. Scout for network. Do learning projects. Do case study examples from web or suggestions. Revisit your learnings.", tags: [.work]),
        .init(title: "Holiday Plan", description: "Select a non-visa country, find cheap accommodation, buy tickets, ask friends to join, plan travel route and locations.", tags: [.entertainment]),
        .init(title: "Organize a family party", description: "Reserve the occasion place. Buy groceries and other stuff related with the party. Invite family members and additional relatives. Arrange a party mix. Buy Drinks !!!", tags: [.family, .entertainment]),
        .init(title: "Finish the mockups of todo app", description: "Learn Figma, imitate the UI design accordingly.", tags: [.study]),
    ]
    
    let dataSetDemoFilled: [ToDoCellModel] =
    [
        .init(title: "Apply for IOS jobs", description: "Edit your CV, linkedin. Scout for network. Do learning projects. Do case study examples from web or suggestions. Revisit your learnings.", tags: [.work]),
        .init(title: "Holiday Plan", description: "Select a non-visa country, find cheap accommodation, buy tickets, ask friends to join, plan travel route and locations.", tags: [.entertainment]),
        .init(title: "Organize a family party", description: "Reserve the occasion place. Buy groceries and other stuff related with the party. Invite family members and additional relatives. Arrange a party mix. Buy Drinks !!!", tags: [.family, .entertainment]),
        .init(title: "Finish the mockups of todo app", description: "Learn Figma, imitate the UI design accordingly.", tags: [.study]),
        .init(title: "5", description: "Five", tags: [.work]),
        .init(title: "6", description: "Six", tags: [.entertainment]),
        .init(title: "7", description: "Seven", tags: [.family, .entertainment]),
        .init(title: "8", description: "Eight", tags: [.study]),
        .init(title: "9", description: "Nine", tags: [.work]),
        .init(title: "10", description: "Ten", tags: [.entertainment]),
        .init(title: "11", description: "Eleven", tags: [.family, .entertainment]),
        .init(title: "12", description: "Twelve", tags: [.study]),
    ]
    
    let dataSetForCoreData: [ToDoCellModel] =
    [
        .init(title: "First", description: "Value1", tags: [.work]),
        .init(title: "Second", description: "Value2", tags: [.entertainment]),
        .init(title: "Third", description: "Done Value1", tags: [.family, .entertainment], doneFlag: true),
        .init(title: "Fourth", description: "Done Value2", tags: [.study], doneFlag: true),
    ]
}
