//
//  NoCategoriesView.swift
//  Flashword
//
//  Created by Alessio Mason on 05/02/24.
//

import SwiftData
import SwiftUI

struct NoCategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var showingAddCategorySheet: Bool
    
    @State private var noWordsInApp = false
    let title = String(localized: "It's a bit quiet here!")
    var description: Text {
        let allWords = String(localized: "All words")
        
        return if noWordsInApp {
            Text("Insert a new category or enter the \"\(allWords)\" category to add your first word!", comment: "The string interpolates the \"All words\" category name")
        } else {
            Text("Insert your first category!")
        }
    }
    
    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "tray.2")
        } description: {
            description
        } actions: {
            Button("Insert a new category") {
                showingAddCategorySheet = true
            }
            .tint(.mint)
            .buttonStyle(.glassProminent)
        }
        .onAppear(perform: checkWordCount)
    }
    
    func checkWordCount() {
        let descriptor = FetchDescriptor<Word>()
        let wordCount = try? modelContext.fetchCount(descriptor)
        
        guard let wordCount else { return }
        if wordCount == 0 {
            noWordsInApp = true
        }
    }
}

#Preview {
    NoCategoriesView(showingAddCategorySheet: .constant(false))
        .modelContainer(for: Word.self, inMemory: true)
}
