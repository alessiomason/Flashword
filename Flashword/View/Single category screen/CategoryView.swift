//
//  CategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct CategoryView: View {
    // category already contains the list of words for the category, but a query is performed nevertheless
    // because it needs to update live after every possible insertion or deletion of words in the category
    let category: Category
    @Query private var words: [Word]
    
    var body: some View {
        WordCardsListView(category: category, words: words)
            .navigationTitle(category.name)
    }
    
    init(category: Category) {
        self.category = category
        
        let predicate = Word.predicate(category: category)
        _words = Query(filter: predicate, sort: Word.sortDescriptors)
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
        
        return NavigationStack {
            CategoryView(category: .example)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
