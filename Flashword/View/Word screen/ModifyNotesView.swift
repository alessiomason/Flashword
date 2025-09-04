//
//  ModifyNotesView.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct ModifyNotesView: View {
    @Environment(\.dismiss) private var dismiss
    private var word: Word
    @State private var notes: String
    @FocusState private var textEditorFocused: Bool
    @State private var showingInfoAlert = false
    
    let infoAlertMessage = String(localized: """
When writing your notes, you can use basic Markdown syntax to format them. For example:

**Bold** text
*Italic* text
~Strikethrough~ text
`Monospace` text
""")
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("Enter your notes here…")
                        .foregroundStyle(.secondary)
                        .padding()
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $notes)
                    .tint(word.primaryColor)
                    .focused($textEditorFocused)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .onAppear {
                        textEditorFocused = true
                    }
            }
            .navigationTitle(word.term)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Writing notes", systemImage: "info.circle") {
                    showingInfoAlert = true
                }
                
                Button {
                    word.notes = notes
                    dismiss()
                } label: {
                    Text("Save")
                        .bold()
                }
            }
            .alert("You can use Markdown in your notes!", isPresented: $showingInfoAlert) {
                Button("OK") { }
            } message: {
                Text(infoAlertMessage)
            }

        }
    }
    
    init(word: Word) {
        self.word = word
        self.notes = word.notes
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return ModifyNotesView(word: .example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
