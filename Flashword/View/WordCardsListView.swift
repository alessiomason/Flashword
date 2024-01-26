//
//  WordsCardsListView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordsCardsListView: View {
    let category: Category?
    @Query private var categories: [Category]
    @Query private var words: [Word]
    
    init(category: Category? = .example) {
        self.category = category
        
        let predicate = Word.predicate(category: category!)
        let sortDescriptors = [
            SortDescriptor(\Word.learntOn, order: .reverse)
        ]
        _words = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
        List {
            Text("Current category: \(category?.name ?? "")")
            
            ForEach(categories) { category in
                Text(category.name)
            }
            
            Divider()
            
            NewWordCardView()
                .listRowSeparator(.hidden)
            
            ForEach(words) { word in
                WordCardView(word: word)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400), category: .example),
            Word(term: "Swift", learntOn: .now, category: .example)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return WordsCardsListView(category: .example)
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
