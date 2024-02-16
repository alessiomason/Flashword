//
//  WordCardsListView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordCardsListView: View {
    @Environment(\.modelContext) private var modelContext
    let category: Category?
    var words: [Word]
    
    @State private var wordToBeReassigned: Word? = nil
    @State private var wordToBeDeleted: Word? = nil
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                NewWordCardView(category: category)
                    .padding(.bottom, 8)
                
                ForEach(words) { word in
                    WordCardView(word: word, wordToBeReassigned: $wordToBeReassigned, wordToBeDeleted: $wordToBeDeleted, showingDeleteAlert: $showingDeleteAlert)
                        .padding(.vertical, 5)
                }
            }
            .padding(.horizontal)
        }
        .sheet(item: $wordToBeReassigned) { word in
            ChangeCategoryView(word: word)
        }
        .alert("Are you sure you want to delete the word \"\(wordToBeDeleted?.term ?? "")\"?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteWord)
        }
    }
    
    init(category: Category? = nil, words: [Word]) {
        self.category = category
        self.words = words
    }
    
    func deleteWord() {
        guard let wordToBeDeleted else { return }
        modelContext.delete(wordToBeDeleted)
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
