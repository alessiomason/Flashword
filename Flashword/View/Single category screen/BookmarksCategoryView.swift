//
//  BookmarksCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI


struct BookmarksCategoryView: View {
    @Query(filter: #Predicate<Word> { $0.bookmarked }, sort: Word.sortDescriptors, animation: .bouncy) private var words: [Word]
    
    var body: some View {
        WordCardsListView(words: words)
            .navigationTitle("Bookmarks")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400), bookmarked: true),
            Word(term: "Swift", learntOn: .now, bookmarked: true)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            BookmarksCategoryView()
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
