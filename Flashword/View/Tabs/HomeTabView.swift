//
//  HomeTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 02/07/25.
//

import CoreSpotlight
import SwiftUI

struct HomeTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var router = Router()
    @State private var quickActionsManager = QuickActionsManager.instance
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CategoryListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .withRouterDestinations(modelContext: modelContext)
        }
        .environment(router)
        .onChange(of: quickActionsManager.quickAction) { oldValue, newValue in
            switch newValue {
                case .showAllWords:
                    router.path.removeAll()
                    router.path.append(.allWordsCategory)
                case .addNewWord:
                    router.path.removeAll()
                default:
                    return
            }
        }
        .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
            handleSpotlight(userActivity: userActivity, modelContext: modelContext, router: router)
        }
    }
}

#Preview {
    HomeTabView()
}
