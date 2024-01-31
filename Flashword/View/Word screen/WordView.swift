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
    let primaryColor: Color
    let secondaryColor: Color
    
    @State private var showingDictionary = false
    @State private var showingChangeCategorySheet = false
    @State private var modifyingNotes = false
    @State private var showingDeleteAlert = false
    @FocusState private var focusingTextEditor: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(decorative: "Leaves and book")
                .resizable()
                .scaledToFit()
                .padding(10)
                .blending(color: primaryColor)
                .opacity(0.5)
            
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Category: \(word.categoryName)", comment: "The category the word belongs to")
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
                            .linearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    Button {
                        modifyingNotes = false
                    } label: {
                        Text("Done")
                            .bold()
                    }
                } else {
                    Button("Modify the notes", systemImage: "square.and.pencil") {
                        modifyingNotes = true
                    }
                }
                
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
            .sheet(isPresented: $showingDictionary) {
                DictionaryView(term: word.term)
                    .ignoresSafeArea()
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
            case let .word(removedWord, _, _):
                // check that the last word in the router path (which has now been removed)
                // is the same word displayed in the view, otherwise something went very wrong
                guard removedWord == word else { fallthrough }
                modelContext.delete(word)
            default:
                fatalError("There was an error removing the word \(word).")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return NavigationStack {
            WordView(word: .example, primaryColor: .mint, secondaryColor: .blue)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
