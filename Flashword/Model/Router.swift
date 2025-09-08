//
//  Router.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

enum RouterDestination: Hashable {
    case allWordsCategory
    case recentlyAddedCategory
    case bookmarksCategory
    case category(category: Category)
    case word(word: Word)
}

@Observable
class Router {
    var path = [RouterDestination]()
}

@MainActor
extension View {
    func withRouterDestinations(modelContext: ModelContext) -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
                case .allWordsCategory:
                    AllWordsCategoryView()
                case .recentlyAddedCategory:
                    RecentlyAddedWordsCategoryView(modelContext: modelContext)
                case .bookmarksCategory:
                    BookmarksCategoryView()
                case let .category(category):
                    CategoryView(category: category)
                case let .word(word):
                    WordPageView(word: word)
            }
        }
    }
}
