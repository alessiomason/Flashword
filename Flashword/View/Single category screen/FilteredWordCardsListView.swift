//
//  FilteredWordCrdsLIstView.swift
//  Flashword
//
//  Created by Alessio Mason on 02/07/25.
//

import SwiftData
import SwiftUI

struct FilteredWordCardsListView: View {
    let category: Category?
    var words: [Word]
    
    let inSearchTab: Bool
    let focusNewWordField: Bool
    let addNewWordToBookmarks: Bool
    let contentUnavailableText: String
    let contentUnavailableDescription: String
    
    @State private var searchText = ""
    
    private var filteredWords: [Word] {
        return words.filter {
            $0.term.lowercased().starts(with: searchText.lowercased())
        }
    }
    
    var body: some View {
        WordCardsListView(category: category, words: filteredWords, inSearchTab: inSearchTab, focusNewWordField: focusNewWordField, addNewWordToBookmarks: addNewWordToBookmarks, contentUnavailableText: contentUnavailableText, contentUnavailableDescription: contentUnavailableDescription)
            .searchable(text: $searchText, prompt: "Search in this category")
    }
    
    init(category: Category? = nil, words: [Word], inSearchTab: Bool = false, focusNewWordField: Bool = false, addNewWordToBookmarks: Bool = false, contentUnavailableText: String? = nil, contentUnavailableDescription: String? = nil) {
        self.category = category
        self.words = words
        self.inSearchTab = inSearchTab
        self.focusNewWordField = focusNewWordField
        self.addNewWordToBookmarks = addNewWordToBookmarks
        self.contentUnavailableText = contentUnavailableText ?? ""
        self.contentUnavailableDescription = contentUnavailableDescription ?? ""
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words: [Word] = [
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(uuid: UUID(), term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            FilteredWordCardsListView(words: words, contentUnavailableText: "No recent words to display", contentUnavailableDescription: "You haven't added any words in the last 30 days: there's nothing to see here!")
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
