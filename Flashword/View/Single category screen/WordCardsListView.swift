//
//  WordCardsListView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordCardsListView: View {
    enum SortingOptions: String, CaseIterable, Codable {
        case alphabetical, creationDate
    }
    
    @Environment(\.modelContext) private var modelContext
    let category: Category?
    var words: [Word]
    
    let focusNewWordField: Bool
    let addNewWordToBookmarks: Bool
    let contentUnavailableText: String
    let contentUnavailableDescription: String
    
    @AppStorage("sortingBy") private var sortingBy = SortingOptions.creationDate
    @State private var searchText = ""
    @State private var wordToBeReassigned: Word? = nil
    @State private var wordToBeDeleted: Word? = nil
    @State private var showingDeleteAlert = false
    
    
    private var displayedWords: [Word] {
        let filteredWords = words.filter {
            $0.term.lowercased().starts(with: searchText.lowercased())
        }
        
        return switch sortingBy {
            case .alphabetical:
                filteredWords.sorted(by: { a, b in
                    a.term < b.term
                })
            case .creationDate:
                filteredWords.sorted(by: { a, b in
                    Calendar.current.compare(a.learntOn, to: b.learntOn, toGranularity: .second) == .orderedDescending
                })
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                NewWordCardView(category: category, focusNewWordField: focusNewWordField, addNewWordToBookmarks: addNewWordToBookmarks)
                    .padding(.bottom, 8)
                
                if displayedWords.isEmpty {
                    ContentUnavailableView(contentUnavailableText, image: "custom.tray.slash", description: Text(contentUnavailableDescription))
                } else {
                    ForEach(displayedWords) { word in
                        WordCardView(word: word, wordToBeReassigned: $wordToBeReassigned, wordToBeDeleted: $wordToBeDeleted, showingDeleteAlert: $showingDeleteAlert)
                            .padding(.vertical, 5)
                    }
                    
                    Text((category == nil) ? "\(words.count) words" : "\(words.count) words in this category")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem {
                Menu {
                    Picker("Sorting", selection: $sortingBy) {
                        Text("Sort alphabetically").tag(SortingOptions.alphabetical)
                        Text("Sort by creation date").tag(SortingOptions.creationDate)
                    }
                } label: {
                    Label("Sorting", systemImage: "arrow.up.arrow.down.circle")
                }
            }
        }
        .sheet(item: $wordToBeReassigned) { word in
            ChangeCategoryView(word: word)
        }
        .alert("Are you sure you want to delete the word \"\(wordToBeDeleted?.term ?? "")\"?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteWord)
        }
    }
    
    init(category: Category? = nil, words: [Word], focusNewWordField: Bool = false, addNewWordToBookmarks: Bool = false, contentUnavailableText: String? = nil, contentUnavailableDescription: String? = nil) {
        self.category = category
        self.words = words
        self.focusNewWordField = focusNewWordField
        self.addNewWordToBookmarks = addNewWordToBookmarks
        self.contentUnavailableText = contentUnavailableText ?? ""
        self.contentUnavailableDescription = contentUnavailableDescription ?? ""
    }
    
    func deleteWord() {
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
            Word(uuid: UUID(), term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            WordCardsListView(words: words, contentUnavailableText: "No recent words to display", contentUnavailableDescription: "You haven't added any words in the last 30 days: there's nothing to see here!")
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
