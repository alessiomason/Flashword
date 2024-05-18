//
//  WordView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct WordView: View {
    let word: Word
    
    var body: some View {
        TabView {
            VStack(alignment: .leading) {
                HStack {
                    word.categoryIcon
                        .padding(.trailing, 4)
                    
                    Text(word.categoryName)
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 16)
                
                Text("Word learnt on \(word.learntOn.formatted(date: .complete, time: .shortened))", comment: "The time the word has been learnt, including the name of the day, the date and the time")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .if(word.category != nil) { view in
                view.containerBackground(word.category!.tintColor.gradient, for: .tabView)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(word.bookmarked ? "Remove from bookmarks" : "Add to bookmarks", systemImage: word.bookmarked ? "bookmark.fill" : "bookmark") {
                        word.bookmarked.toggle()
                    }
                }
            }
            
            if !word.notes.isEmpty {
                VStack(alignment: .leading) {
                    Text("Notes")
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(word.notes)
                        .padding(.horizontal)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .if(word.category != nil) { view in
                    view.containerBackground(word.category!.tintColor.gradient, for: .tabView)
                }
            }
        }
        .tabViewStyle(.verticalPage)
        .navigationTitle(word.term)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return NavigationStack {
            WordView(word: .example)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
