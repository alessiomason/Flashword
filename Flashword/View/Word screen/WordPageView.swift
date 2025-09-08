//
//  WordPageView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordPageView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Bindable var word: Word
    
    @State private var showingChangeCategorySheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        WordView(word: word)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Change category", systemImage: "tray.full") {
                            showingChangeCategorySheet = true
                        }
                        
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingChangeCategorySheet) {
                ChangeCategoryView(word: word)
            }
            .alert("Are you sure you want to delete the word \"\(word.term)\"?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive, action: deleteWord)
            }
    }
    
    private func deleteWord() {
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
            WordPageView(word: .example)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
