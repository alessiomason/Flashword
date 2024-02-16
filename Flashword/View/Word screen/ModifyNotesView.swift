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
    @Bindable var word: Word
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                if word.notes.isEmpty {
                    Text("Enter your notes here…")
                        .foregroundStyle(.secondary)
                        .padding()
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $word.notes)
                    .scrollContentBackground(.hidden)
                    .padding()
            }
            .navigationTitle("Modify the notes of \"\(word.term)\"")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .bold()
                }
            }
        }
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
