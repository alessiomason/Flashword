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
    case searchWord
}

@Observable
class QuickActionsManager: ObservableObject {
    static let instance = QuickActionsManager()
    var quickAction: QuickAction? = nil
    
    func handleQaItem(_ item: UIApplicationShortcutItem) {
        switch item.type {
            case "ShowAllWords":
                quickAction = .showAllWords
            case "AddNewWord":
                quickAction = .addNewWord
            case "SearchWord":
                quickAction = .searchWord
            default:
                return
        }
    }
}
