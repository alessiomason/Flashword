//
//  WordView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Bindable var word: Word
    
    @State private var showingChangeCategorySheet = false
    @State private var showingModifyNotesSheet = false
    @State private var showingDeleteAlert = false
    
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
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(.init(word.notes))     // allows for basic Markdown text
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                    
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
                }
                
                Menu {
                    Button("Change category", systemImage: "tray.full") {
                        showingChangeCategorySheet = true
                    }
                    .tint(.primary)
                    
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showingDeleteAlert = true
                    }
                    .tint(.red)
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
            .sheet(isPresented: $showingModifyNotesSheet) {
                ModifyNotesView(word: word)
            }
            .sheet(isPresented: $showingChangeCategorySheet) {
                ChangeCategoryView(word: word)
            }
            .alert("Are you sure you want to delete the word \"\(word.term)\"?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive, action: deleteWord)
            }
        }
    }
    
    func deleteWord() {
        let removedDestination = router.path.removeLast()
        switch removedDestination {
            case let .word(removedWord):
                // check that the last word in the router path (which has now been removed)
                // is the same word displayed in the view, otherwise something went very wrong
                guard removedWord == word else { fallthrough }
                removedWord.deleteIndex()
                modelContext.delete(word)
            default:
                fatalError("There was an error removing the word \(word.term).")
        }
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
