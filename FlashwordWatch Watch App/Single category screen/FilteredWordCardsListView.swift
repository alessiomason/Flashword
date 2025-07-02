//
//  FilteredWordCardsListView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct FilteredWordCardsListView: View {
    @Environment(\.modelContext) private var modelContext
    let category: Category?
    var words: [Word]
    
    let addNewWordToBookmarks: Bool
    let contentUnavailableText: String
    let contentUnavailableDescription: String
    
    @State private var showingAddWordSheet = false
    
    var body: some View {
        List {
            Section {
                AddWordView(addNewWordToBookmarks: addNewWordToBookmarks)
                
                if words.isEmpty {
                    ContentUnavailableView(contentUnavailableText, image: "custom.tray.slash", description: Text(contentUnavailableDescription))
                } else {
                    ForEach(words) { word in
                        WordCardView(word: word)
                    }
                }
            } footer: {
                if !words.isEmpty {
                    Text((category == nil) ? "\(words.count) words" : "\(words.count) words in this category")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
            }
        }
        .if(category != nil) { view in
            view.containerBackground(category!.tintColor.gradient, for: .navigation)
        }
        .listStyle(.carousel)
    }
    
    init(category: Category? = nil, words: [Word], focusNewWordField: Bool = false, addNewWordToBookmarks: Bool = false, contentUnavailableText: String? = nil, contentUnavailableDescription: String? = nil) {
        self.category = category
        self.words = words
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
