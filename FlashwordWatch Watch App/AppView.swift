//
//  AppView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct AppView: View {
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CategoryListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .navigationDestination(for: RouterDestination.self) { destination in
                    switch destination {
                        case .allWordsCategory:
                            AllWordsCategoryView()
                        case .recentlyAddedCategory:
                            RecentlyAddedWordsCategoryView()
                        case .bookmarksCategory:
                            BookmarksCategoryView()
                        case let .category(category):
                            CategoryView(category: category)
                        case let .word(word):
                            WordView(word: word)
                    }
                }
        }
        .tint(router.tintColor)
        .environment(router)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400), bookmarked: true),
            Word(term: "Swift", learntOn: .now, category: .example)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return AppView()
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
