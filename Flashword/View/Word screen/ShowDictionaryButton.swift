//
//  ShowDictionaryButton.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct ShowDictionaryButton: View {
    let word: Word
    
    @AppStorage("alreadyUsedDictionary") private var alreadyUsedDictionary = false
    @State private var showingDictionaryExplanationAlert = false
    @State private var showingDictionary = false
    
    var body: some View {
        Button("Look up word") {
            if alreadyUsedDictionary {
                showingDictionary = true
            } else {
                showingDictionaryExplanationAlert = true
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(
            .linearGradient(colors: [word.primaryColor, word.secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
        .alert("Looking up a word", isPresented: $showingDictionaryExplanationAlert) {
            Button("Continue") {
                alreadyUsedDictionary = true
                showingDictionary = true
            }
        } message: {
            Text("Word definitions are provided by the system dictionaries. You can manage your dictionaries from the \"Manage Dictionaries\" button.", comment: "An explanation (shown only once) of the system dictionaries. Make sure the name of the button matches the one displayed by the dictionary view Apple provides.")
        }
        .sheet(isPresented: $showingDictionary) {
            DictionaryView(term: word.term)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return ShowDictionaryButton(word: .example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
