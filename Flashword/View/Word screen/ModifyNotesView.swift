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
                    .focused($textEditorFocused)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .onAppear {
                        textEditorFocused = true
                    }
            }
            .navigationTitle("Modify the notes of \"\(word.term)\"")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    word.notes = notes
                    dismiss()
                } label: {
                    Text("Done")
                        .bold()
                }
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
