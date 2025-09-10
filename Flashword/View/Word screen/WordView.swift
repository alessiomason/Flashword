//
//  WordView.swift
//  Flashword
//
//  Created by Alessio Mason on 05/09/25.
//

import SwiftData
import SwiftUI

struct WordView: View {
    @Bindable var word: Word
    @State private var showingModifyNotesSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(decorative: "Leaves and book")
                .resizable()
                .scaledToFit()
                .padding(10)
                .frame(maxHeight: 300)
                .blendingVertically(color: word.primaryColor)
                .opacity(0.5)
            
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Category: \(word.categoryName)", comment: "The category the word belongs to")
                        .padding(.bottom, 5)
                    
                    Text("Word learnt on \(word.learntOn.formatted(date: .complete, time: .shortened))", comment: "The time the word has been learnt, including the name of the day, the date and the time")
                        .padding(.bottom, 20)
                    
                    Text("Notes")
                        .padding(.bottom, 5)
                        .font(.system(.title2, design: .serif))
                        .fontWeight(.semibold)
                    
                    if word.notes.isEmpty {
                        Button("Add notes…") {
                            showingModifyNotesSheet = true
                        }
                        .padding(.horizontal, 5)
                        .tint(word.primaryColor)
                    } else {
                        Text(.init(word.notes))     // allows for basic Markdown text
                            .padding(.horizontal, 5)
                    }
                    
                    ShowDictionaryButton(term: word.term, primaryColor: word.primaryColor, secondaryColor: word.secondaryColor)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle(word.term)
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                Button("Modify the notes", systemImage: "square.and.pencil") {
                    showingModifyNotesSheet = true
                }
                
                Button(word.bookmarked ? "Remove from bookmarks" : "Add to bookmarks", systemImage: word.bookmarked ? "bookmark.fill" : "bookmark") {
                    word.bookmarked.toggle()
                }            }
            .sheet(isPresented: $showingModifyNotesSheet) {
                ModifyNotesView(word: word)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return WordView(word: .example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
