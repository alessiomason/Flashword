//
//  AppView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import CoreSpotlight
import SwiftData
import SwiftUI

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("alreadyIndexedWords") private var alreadyIndexedWords = false  // app indexes all words only once (for backwords compatibility), then indexes new ones at insertion time
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
        .task {
            Task.detached(priority: .background) {
                if !alreadyIndexedWords {
                    indexWords(modelContext: modelContext)
                    alreadyIndexedWords = true
                }
            }
        }
    }
}


@Sendable private func indexWords(modelContext: ModelContext) {
    CSSearchableIndex.default().deleteAllSearchableItems()
    
    let descriptor = FetchDescriptor<Word>()
    let words = try? modelContext.fetch(descriptor)
    guard let words else { return }
    
    var searchableItems = [CSSearchableItem]()
    
    for word in words {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.displayName = word.term
        attributeSet.containerIdentifier = word.category?.name
        attributeSet.containerDisplayName = word.categoryName
        attributeSet.addedDate = word.learntOn
        
        let searchableItem = CSSearchableItem(uniqueIdentifier: nil, domainIdentifier: word.categoryName, attributeSet: attributeSet)
        searchableItems.append(searchableItem)
    }
    
    CSSearchableIndex.default().indexSearchableItems(searchableItems)
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

