//
//  SearchTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 02/07/25.
//

import SwiftData
import SwiftUI

struct SearchTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var router = Router()
    @Query private var words: [Word]
    
    let searchText: String
    
    private var filteredWords: [Word] {
        return words.filter {
            $0.term.lowercased().starts(with: searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if searchText.isEmpty {
                    Text("Recents")
                } else {
                    WordCardsListView(words: filteredWords, inSearchTab: true)
                }
            }
            .navigationTitle("Search")
            .withRouterDestinations(modelContext: modelContext)
        }
        .environment(router)
    }
}

#Preview {
    SearchTabView(searchText: "")
}
