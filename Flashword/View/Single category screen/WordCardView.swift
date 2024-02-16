//
//  WordCardView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct WordCardView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    let word: Word
    
    @Binding var wordToBeReassigned: Word?
    @Binding var wordToBeDeleted: Word?
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        Button {
            router.path.append(RouterDestination.word(word: word))
        } label: {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading) {
                    Text(word.term)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if word.notes.isEmpty {
                        Text("No notes", comment: "A short phrase describing the absence of notes in the WordCard")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(word.notes)
                            .lineLimit(1)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                Text(word.learntOn.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(
            .linearGradient(colors: [word.primaryColor, word.secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
        .contextMenu {
            Button("Change category", systemImage: "tray.full") {
                wordToBeReassigned = word
            }
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                wordToBeDeleted = word
                showingDeleteAlert = true
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return WordCardView(word: .example, wordToBeReassigned: .constant(nil), wordToBeDeleted: .constant(nil), showingDeleteAlert: .constant(false))
            .padding()
            .modelContainer(container)
            .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
