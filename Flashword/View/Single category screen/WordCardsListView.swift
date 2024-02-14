//
//  WordCardsListView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordCardsListView: View {
    let category: Category?
    var words: [Word]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                NewWordCardView(category: category)
                    .padding(.bottom, 8)
                
                ForEach(words) { word in
                    WordCardView(word: word)
                        .padding(.vertical, 5)
                }
            }
            .padding(.horizontal)
        }
    }
    
    init(category: Category? = nil, words: [Word]) {
        self.category = category
        self.words = words
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return WordCardsListView(words: words)
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
