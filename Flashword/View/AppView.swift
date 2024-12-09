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
    @AppStorage("alreadyUpdatedWordsUuid") private var alreadyUpdatedWordsUuid = false
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
        .onAppear {
            indexWords(modelContext: modelContext, alreadyUpdatedWordsUuid: alreadyUpdatedWordsUuid)
            alreadyUpdatedWordsUuid = true
        }
        .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
            handleSpotlight(userActivity: userActivity, modelContext: modelContext, router: router)
        }
    }
}

@Sendable private func indexWords(modelContext: ModelContext, alreadyUpdatedWordsUuid: Bool) {
    CSSearchableIndex.default().deleteAllSearchableItems()
    
    let descriptor = FetchDescriptor<Word>(
        predicate: #Predicate { word in
            word.spotlightIndexed == false
        }
    )
    let words = try? modelContext.fetch(descriptor)
    guard let words else { return }
    
    var searchableItems = [CSSearchableItem]()
    
    for word in words {
        // This solves a bug with SwiftData's lightweight migration:
        // if words were already present when updating to thw new model with thw UUID (previously absent),
        // all words are created withe the same UUID.
        // This creates a unique UUID for every word only at first launch.
        if !alreadyUpdatedWordsUuid {
            word.uuid = UUID()
        }
        
        let searchableItem = word.createSpotlightSearchableItem()
        searchableItems.append(searchableItem)
        word.spotlightIndexed = true
    }
    
    CSSearchableIndex.default().indexSearchableItems(searchableItems)
}

func handleSpotlight(userActivity: NSUserActivity, modelContext: ModelContext, router: Router) {
    guard let string = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
    guard let queryUuid = UUID(uuidString: string) else { return }
    
    let descriptor = FetchDescriptor<Word>(
        predicate: #Predicate<Word> { word in
            word.uuid == queryUuid
        }
    )
    
    guard let word = try? modelContext.fetch(descriptor).first else { return }
    router.path.append(RouterDestination.word(word: word))
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400), bookmarked: true),
            Word(uuid: UUID(), term: "Swift", learntOn: .now, category: .example)
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

