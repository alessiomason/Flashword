//
//  NewWordCardView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct NewWordCardView: View {
    @State private var term = ""
    @Environment(Router.self) var router
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            TextField("Enter a new term", text: $term)
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
    
    func insertNewWord() {
        guard !term.isEmpty else { return }
        
        let word = Word(term: term.trimmingCharacters(in: .whitespacesAndNewlines), learntOn: .now)
        router.path.append(word)
        modelContext.insert(word)
        term = ""
    }
}

#Preview {
    NewWordCardView()
        .environment(Router())
}
