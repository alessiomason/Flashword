//
//  AddWordView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 29/05/24.
//

import SwiftData
import SwiftUI

struct AddWordView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let category: Category? = nil
    @State private var term = ""
    @State private var showingDuplicateWordWarning = false
    @State private var duplicateWordIsInDifferentCategory = false
    
    let addNewWordToBookmarks: Bool
    
    var body: some View {
        TextFieldLink(prompt: Text("Enter a new word")) {
            HStack {
                Image(systemName: "plus")
                    .padding(.horizontal, 8)
                Text("Enter a new word")
            }
        } onSubmit: { text in
            term = text
            checkWordBeforeInserting()
        }
        .alert("The word already exists!", isPresented: $showingDuplicateWordWarning) {
            Button("Cancel", role: .cancel) { }
            Button("Add anyway", action: insertNewWord)
        } message: {
            let trimmedTerm = term.trimmingCharacters(in: .whitespaces)
            
            if duplicateWordIsInDifferentCategory {
                Text("The word \"\(trimmedTerm)\" has already been saved in the app, but in a different category.")
            } else {
                Text("The word \"\(trimmedTerm)\" has already been saved in this category.")
            }
        }
    }
    
    init(addNewWordToBookmarks: Bool = false) {
        self.addNewWordToBookmarks = addNewWordToBookmarks
    }
    
    func fetchDuplicates() -> [Word]? {
        let trimmedTerm = term.trimmingCharacters(in: .whitespaces)
        
        let descriptor = FetchDescriptor<Word>(
            predicate: #Predicate { word in
                word.term == trimmedTerm
            }
        )
        return try? modelContext.fetch(descriptor)
    }
    
    @MainActor func checkWordBeforeInserting() {
        let duplicates = fetchDuplicates()
        guard let duplicates else {
            insertNewWord()     // since words don't have to be unique, insert anyway
            return
        }
        
        if duplicates.isEmpty {
            insertNewWord()
        } else {
            duplicateWordIsInDifferentCategory = true
            for duplicate in duplicates {
                if duplicate.category?.name == category?.name {
                    duplicateWordIsInDifferentCategory = false
                    break
                }
            }
            showingDuplicateWordWarning = true
        }
    }
    
    @MainActor func insertNewWord() {
        let trimmedTerm = term.trimmingCharacters(in: .whitespaces)
        guard !trimmedTerm.isEmpty else { return }
        
        let word = Word(uuid: UUID(), term: trimmedTerm, learntOn: .now, category: category, bookmarked: addNewWordToBookmarks)
        modelContext.insert(word)
        router.path.append(RouterDestination.word(word: word))
        term = ""
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return AddWordView()
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
