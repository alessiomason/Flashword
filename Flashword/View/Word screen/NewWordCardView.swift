//
//  NewWordCardView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct NewWordCardView: View {
    @Environment(Router.self) var router
    @Environment(\.modelContext) var modelContext
    @State private var term = ""
    let category: Category?
    
    var body: some View {
        VStack {
            TextField("Enter a new word", text: $term)
                .textFieldStyle(.roundedBorder)
            
            Button("Add", action: insertNewWord)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .buttonStyle(.plain)
                .background(
                    .linearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(
                    .linearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        }
    }
    
    init(category: Category? = nil) {
        self.category = category
    }
    
    func insertNewWord() {
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTerm.isEmpty else { return }
        
        let word = Word(term: trimmedTerm, learntOn: .now, category: category)
        modelContext.insert(word)
        router.path.append(RouterDestination.word(word: word))
        term = ""
    }
}

#Preview {
    NewWordCardView()
        .environment(Router())
}
