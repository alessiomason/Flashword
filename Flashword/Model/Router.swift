//
//  Router.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

enum RouterDestination: Hashable {
    case allWordsCategory
    case recentlyAddedCategory(focusNewWordField: Bool = false)
    case bookmarksCategory
    case category(category: Category)
    case word(word: Word)
}

@Observable
class Router {
    var path = [RouterDestination]()
    
    var tintColor: Color? {
        let defaultTintColor = ColorChoice.choices[UserDefaults.standard.integer(forKey: "defaultColorChoiceId")]?.tintColor
        
        guard path.count > 0 else { return defaultTintColor }
        let currentDestination = path[path.count - 1]
        
        return switch currentDestination {
            case let .category(category):
                category.tintColor
            case let .word(word):
                word.category?.tintColor ?? defaultTintColor
            default:
                defaultTintColor
        }
    }
}
