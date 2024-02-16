//
//  NewWordCardView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct NewWordCardView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    
    let category: Category?
    let primaryColor: Color
    let secondaryColor: Color
    @State private var term = ""
    
    var body: some View {
        VStack {
            TextField("Enter a new word", text: $term)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                ShowDictionaryButton(term: term, primaryColor: .gray.opacity(0.25), secondaryColor: .gray, smaller: true)
                
                Button("Add", action: insertNewWord)
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
    }
    
    init(category: Category? = nil) {
        self.category = category
        self.primaryColor = category?.primaryColor ?? .mint
        self.secondaryColor = category?.secondaryColor ?? .blue
    }
    
    func insertNewWord() {
        let trimmedTerm = term.trimmingCharacters(in: .whitespaces)
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
