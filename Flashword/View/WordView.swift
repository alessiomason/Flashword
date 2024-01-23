//
//  WordView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordView: View {
    @Environment(Router.self) var router
    @Environment(\.modelContext) var modelContext
    @Bindable var word: Word
    
    @State private var showingDictionary = false
    @State private var modifyingNotes = false
    @State private var showingDeleteAlert = false
    @FocusState private var focusingTextEditor: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Category: \(word.term)", comment: "The category the word belongs to")
                    .padding(.bottom, 5)
                
                Text("Word learnt on \(word.learntOn.formatted(date: .complete, time: .shortened))", comment: "The time the word has been learnt, including the name of the day, the date and the time")
                    .padding(.bottom, 20)
                
                Text(modifyingNotes ? "Modify the notes" : "Notes", comment: "Button for modifying the word notes")
                    .padding(.bottom, 5)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if modifyingNotes {
                    ZStack(alignment: .topLeading) {
                        if word.notes.isEmpty {
                            Text("Enter your notes here...")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $word.notes)
                            .frame(height: 200)
                            .scrollContentBackground(.hidden)
                            .focused($focusingTextEditor)
                            .onAppear {
                                focusingTextEditor = true
                            }
                    }
                } else {
                    Text(word.notes)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                }
                
                if !modifyingNotes {
                    Button("Look up word") {
                        showingDictionary = true
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        .linearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(word.term)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            if modifyingNotes {
                Button("Done") {
                    modifyingNotes = false
                }
            } else {
                Button("Modify the notes", systemImage: "square.and.pencil") {
                    modifyingNotes = true
                }
            }
            
            Menu {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    showingDeleteAlert = true
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
        .sheet(isPresented: $showingDictionary) {
            DictionaryView(term: word.term)
                .ignoresSafeArea()
        }
        .alert("Confirm deletion", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteWord)
        } message: {
            Text("Are you sure you want to delete the word \"\(word.term)\"?", comment: "Confirmation message for deleting a word")
        }
    }
    
    func deleteWord() {
        let removedWord = router.path.popLast()
        guard removedWord == word else {
            fatalError("There was an error removing the word \(word.term)")
        }
        modelContext.delete(word)
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
