//
//  QuickActions.swift
//  Flashword
//
//  Created by Alessio Mason on 19/12/24.
//

import SwiftUI

enum QuickAction: Hashable {
    case showAllWords
    case addNewWord
}

@Observable
class QuickActionsManager: ObservableObject {
    static let instance = QuickActionsManager()
    var quickAction: QuickAction? = nil
    
    func handleQaItem(_ item: UIApplicationShortcutItem) {
        if item.type == "ShowAllWords" {
            quickAction = .showAllWords
        } else if item.type == "AddNewWord" {
            quickAction = .addNewWord
        }
    }
}
