//
//  NewWordCardView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import StoreKit
import SwiftData
import SwiftUI

struct NewWordCardView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Environment(\.requestReview) private var requestReview
    
    let category: Category?
    let primaryColor: Color
    let secondaryColor: Color
    @State private var term = ""
    @State private var showingDuplicateWordWarning = false
    @State private var duplicateWordIsInDifferentCategory = false
    
    var body: some View {
        VStack {
            TextField("Enter a new word", text: $term)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                ShowDictionaryButton(
                    term: term,
                    primaryColor: Color(red: 0.886, green: 0.886, blue: 0.890),
                    secondaryColor: Color(red: 0.557, green: 0.557, blue: 0.576),
                    smaller: true
                )
                
                Button("Add", action: checkWordBeforeInserting)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .buttonStyle(.plain)
                    .background(
                        .linearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 8)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(
                    .linearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
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
    
    init(category: Category? = nil) {
        self.category = category
        self.primaryColor = category?.primaryColor ?? .mint
        self.secondaryColor = category?.secondaryColor ?? .blue
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
        
        let word = Word(term: trimmedTerm, learntOn: .now, category: category)
        modelContext.insert(word)
        router.path.append(RouterDestination.word(word: word))
        term = ""
        
        let descriptor = FetchDescriptor<Word>()
        let wordCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        if wordCount >= 10 {
            requestReview()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return NewWordCardView()
            .padding()
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
