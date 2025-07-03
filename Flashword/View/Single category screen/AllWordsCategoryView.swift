//
//  AllWordsCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct AllWordsCategoryView: View {
    @Query(sort: Word.sortDescriptors, animation: .bouncy) private var words: [Word]
    
    let contentUnavailableLocalizedText = String(localized: "No words to display")
    let contentUnavailableLocalizedDescription = String(localized: "You haven't added any words yet: you can start now!")
    
    var body: some View {
        WordCardsListView(words: words, contentUnavailableText: contentUnavailableLocalizedText, contentUnavailableDescription: contentUnavailableLocalizedDescription)
            .navigationTitle("All words")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(uuid: UUID(), term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            AllWordsCategoryView()
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
