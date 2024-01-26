//
//  CategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct CategoryView: View {
    let category: Category
    
    var body: some View {
        WordCardsListView(words: category.words)
            .navigationTitle(category.name)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(term: "Swift", learntOn: .now, category: .example)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return CategoryView(category: .example)
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
