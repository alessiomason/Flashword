//
//  CategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
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
    
    @State private var showingModifyCategory = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        WordCardsListView(category: category, words: words)
            .navigationTitle(category.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit category", systemImage: "paintbrush") {
                            showingModifyCategory = true
                        }
                        
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }.sheet(isPresented: $showingModifyCategory) {
                AddModifyCategoryView(category: category)
            }
            .alert("Are you sure you want to delete this category?", isPresented: $showingDeleteAlert) {
                Button("Delete words too", role: .destructive, action: {
                    deleteCategory(includingWords: true)
                })
                Button("Delete but keep words", role: .destructive, action: {
                    deleteCategory(includingWords: false)
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You can delete the category and all its associated words, or delete the category alone and mark all the words as uncategorized.")
            }
    }
    
    init(category: Category) {
        self.category = category
        
        let predicate = Word.predicate(category: category)
        _words = Query(filter: predicate, sort: Word.sortDescriptors, animation: .bouncy)
    }
    
    func deleteCategory(includingWords: Bool) {
        let removedDestination = router.path.removeLast()
        switch removedDestination {
            case let .category(category: removedCategory):
                // check that the last category in the router path (which has now been removed)
                // is the same category displayed in the view, otherwise something went very wrong
                guard removedCategory == category else { fallthrough }
                
                if includingWords {
                    category.unwrappedWords.forEach { word in
                        modelContext.delete(word)
                    }
                }
                modelContext.delete(category)
            default:
                fatalError("There was an error removing the category \(category.name).")
        }
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
