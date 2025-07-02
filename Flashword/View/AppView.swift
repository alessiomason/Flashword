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
    @State private var quickActionsManager = QuickActionsManager.instance
    
    @State private var searchText = ""
    
    private var homeTabView = HomeTabView()
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                homeTabView
            }
            
            Tab("Quiz", systemImage: "questionmark.text.page") {
                Text("Quiz tab")
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchTabView(searchText: searchText)
            }
        }
        .searchable(text: $searchText)
        .tabBarMinimizeBehavior(.onScrollDown)
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
            handleSpotlight(userActivity: userActivity, modelContext: modelContext, router: homeTabView.router)
        }
    }
    
    private func handleQuickActions() {
        switch quickActionsManager.quickAction {
            case .showAllWords:
                homeTabView.router.path.append(.allWordsCategory)
            case .addNewWord:
                homeTabView.router.path.append(.recentlyAddedCategory(focusNewWordField: true))
            case .none:
                return
        }
        
        quickActionsManager.quickAction = nil
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

