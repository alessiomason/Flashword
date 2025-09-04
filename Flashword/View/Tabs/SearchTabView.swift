//
//  SearchTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 02/07/25.
//

import SwiftData
import SwiftUI

struct SearchTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var router = Router()
    @State private var quickActionsManager = QuickActionsManager.instance
    
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
    @Query(sort: Word.sortDescriptors) private var words: [Word]
    
    @State private var searchText = ""
    @State private var focusingSearchField = false
    
    @State private var wordToBeReassigned: Word? = nil
    @State private var wordToBeDeleted: Word? = nil
    @State private var showingDeleteAlert = false
    
    private var filteredCategories: [Category] {
        categories.filter {
            $0.name.lowercased().starts(with: searchText.lowercased())
        }
    }
    
    private var filteredWords: [Word] {
        var matchesInWord = words.filter {
            $0.term.lowercased().starts(with: searchText.lowercased())
        }
        
        let matchesInNotes = words.filter {
            $0.notes.lowercased().contains(searchText.lowercased())
        }
        
        for match in matchesInNotes {
            if !matchesInWord.contains(match) {
                matchesInWord.append(match)
            }
        }
        
        return matchesInWord
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if searchText.isEmpty {
                    Text("Recents")
                } else {
                    List {
                        if !filteredCategories.isEmpty {
                            Section("Categories") {
                                ForEach(filteredCategories) { category in
                                    NavigationLink(destination: CategoryView(category: category)) {
                                        CategoryListItemView(category: category)
                                    }
                                }
                            }
                        }
                        
                        Section("Words") {
                            ForEach(filteredWords) { word in
                                WordCardView(word: word, wordToBeReassigned: $wordToBeReassigned, wordToBeDeleted: $wordToBeDeleted, showingDeleteAlert: $showingDeleteAlert)
                                    .padding(.vertical, -6)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .sheet(item: $wordToBeReassigned) { word in
                        ChangeCategoryView(word: word)
                    }
                    .alert("Are you sure you want to delete the word \"\(wordToBeDeleted?.term ?? "")\"?", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive, action: deleteWord)
                    }
                }
            }
            .navigationTitle("Search")
            .withRouterDestinations(modelContext: modelContext)
        }
        .searchable(text: $searchText, isPresented: $focusingSearchField)
        .environment(router)
        .onChange(of: quickActionsManager.quickAction) { oldValue, newValue in
            switch newValue {
                case .searchWord:
                    focusKeyboard()
                default:
                    return
            }
        }
    }
    
    /// A function used when arriving from Quick Actions to automatically focus the keyboard.
    private func focusKeyboard() {
        router.path.removeAll()
        searchText = ""
        focusingSearchField = true
    }
    
    private func deleteWord() {
        guard let wordToBeDeleted else { return }
        wordToBeDeleted.deleteIndex()
        modelContext.delete(wordToBeDeleted)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words: [Word] = [
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400)),
            Word(uuid: UUID(), term: "Testing Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return SearchTabView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
