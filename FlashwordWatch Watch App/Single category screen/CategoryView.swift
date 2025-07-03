//
//  CategoryView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct CategoryView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    
    // category already contains the list of words for the category, but a query is performed nevertheless
    // because it needs to update live after every possible insertion or deletion of words in the category
    let category: Category
    @Query private var words: [Word]
    
    let contentUnavailableLocalizedText = String(localized: "No words in this category")
    let contentUnavailableLocalizedDescription = String(localized: "You haven't added any words to this category yet: there's nothing to see here!")
    
    var body: some View {
        WordCardsListView(category: category, words: words, contentUnavailableText: contentUnavailableLocalizedText, contentUnavailableDescription: contentUnavailableLocalizedDescription)
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
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(uuid: UUID(), term: "Swift", learntOn: .now, category: .example)
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
