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
    @AppStorage("spotlightEnabled") private var spotlightEnabled = true
    @State private var router = Router()
    @State private var quickActionsManager = QuickActionsManager.instance
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CategoryListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .navigationDestination(for: RouterDestination.self) { destination in
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
                            WordView(word: word)
                    }
                }
        }
        .tint(router.tintColor)
        .environment(router)
        .onAppear {
            handleQuickActions()
        }
        .onChange(of: quickActionsManager.quickAction, { _, _ in
            handleQuickActions()
        })
        .onAppear {
            if spotlightEnabled {
                indexWords(modelContext: modelContext, alreadyUpdatedWordsUuid: alreadyUpdatedWordsUuid)
                alreadyUpdatedWordsUuid = true
            }
        }
        .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
            handleSpotlight(userActivity: userActivity, modelContext: modelContext, router: router)
        }
    }
    
    private func handleQuickActions() {
        switch quickActionsManager.quickAction {
            case .showAllWords:
                router.path.append(.allWordsCategory)
            case .addNewWord:
                router.path.append(.recentlyAddedCategory)
            case .none:
                return
        }
    }
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

