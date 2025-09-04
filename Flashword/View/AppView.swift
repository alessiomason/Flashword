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
    enum AppTab {
        case words, quiz, search
    }
    
    @Environment(\.modelContext) private var modelContext
    @AppStorage("alreadyUpdatedWordsUuid") private var alreadyUpdatedWordsUuid = false
    @AppStorage("spotlightEnabled") private var spotlightEnabled = true
    @State private var quickActionsManager = QuickActionsManager.instance
    
    @State private var selectedTab = AppTab.words
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Words", systemImage: "text.book.closed", value: .words) {
                DismissableKeyboardView {
                    HomeTabView()
                }
            }
            
            Tab("Quiz", systemImage: "questionmark.text.page", value: .quiz) {
                QuizTabView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                SearchTabView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.81), trigger: selectedTab)
        .addKeyboardVisibilityToEnvironment()
        .onAppear {
            handleQuickActions()
        }
        .onChange(of: quickActionsManager.quickAction) { _, _ in
            handleQuickActions()
        }
        .onAppear {
            if spotlightEnabled {
                indexWords(modelContext: modelContext, alreadyUpdatedWordsUuid: alreadyUpdatedWordsUuid)
                alreadyUpdatedWordsUuid = true
            }
        }
        .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
            selectedTab = .words
        }
    }
    
    private func handleQuickActions() {
        switch quickActionsManager.quickAction {
            case .showAllWords:
                selectedTab = .words
                
            case .addNewWord:
                selectedTab = .words
                // NewWordCardView watches for changes in quickActionsManager.quickAction and automatically focuses the text field in this specific case
                
            case .searchWord:
                selectedTab = .search
                
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

