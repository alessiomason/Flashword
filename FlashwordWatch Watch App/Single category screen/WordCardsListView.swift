//
//  WordCardsListView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct WordCardsListView: View {
    @Environment(\.modelContext) private var modelContext
    let category: Category?
    var words: [Word]
    
    @State private var showingAddWordSheet = false
    
    var body: some View {
        List {
            Section {
                AddWordView()
                
                ForEach(words) { word in
                    WordCardView(word: word)
                }
            } footer: {
                Text((category == nil) ? "\(words.count) words" : "\(words.count) words in this category")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
        }
        .if(category != nil) { view in
            view.containerBackground(category!.tintColor.gradient, for: .navigation)
        }
        .listStyle(.carousel)
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
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(uuid: UUID(), term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            WordCardsListView(words: words)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
