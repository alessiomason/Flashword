//
//  Router.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

enum RouterDestination: Hashable {
    case allWordsCategory
    case category(category: Category)
    case word(word: Word)
}

@Observable
class Router {
    var path = [RouterDestination]()
    
    var tintColor: Color? {
        guard path.count > 0 else { return nil }
        let currentDestination = path[path.count - 1]
        
        return switch currentDestination {
            case let .category(category):
                category.secondaryColor
            case let .word(word):
                word.category?.secondaryColor ?? .blue
            default:
                nil
        }
    }
}
