//
//  RecentlySearchedView.swift
//  Flashword
//
//  Created by Alessio Mason on 05/09/25.
//

import SwiftData
import SwiftUI

struct RecentlySearchedView: View {
    @Query(filter: #Predicate<Word> { $0.lastSearchedOn != nil }, sort: [SortDescriptor(\Word.lastSearchedOn, order: .reverse)]) private var words: [Word]
    
    private var searchedLastWeek: [Word] {
        words.filter { word in
            guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) else { return false }
            return word.lastSearchedOn! >= sevenDaysAgo
        }
    }
    
    var body: some View {
        // Testo delle ultime 5 ricerce recenti salvato in UserDefaults, come Apple Music
        
        ScrollView {
            LazyVStack {
                HStack {
                    Text("Recently searched")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .padding(.horizontal, 2)
                .padding(.bottom, 8)
                
                ForEach(searchedLastWeek.prefix(20)) { word in
                    WordCardView(word: word, wordToBeReassigned: .constant(nil), wordToBeDeleted: .constant(nil), showingDeleteAlert: .constant(false))
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words: [Word] = [.example, .otherExample]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return RecentlySearchedView()
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}

