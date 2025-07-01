//
//  ShowDictionaryButton.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct ShowDictionaryButton: View {
    let term: String
    let dictionaryHasDefinition: Bool
    let primaryColor: Color
    let secondaryColor: Color
    var smallerButton: Bool
    
    @AppStorage("alreadyUsedDictionary") private var alreadyUsedDictionary = false
    @State private var showingDictionaryExplanationAlert = false
    @State private var showingDictionary = false
    
    var buttonText: String {
        if smallerButton {
            String(localized: "Look up")
        } else {
            String(localized: "Look up word")
        }
    }
    
    var body: some View {
        // UIReferenceLibraryViewController is not available on the Mac, so don't show the button altogether
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            // smaller button is used for text fields, so avoid button appearing and disappearing as the
            // user types, always show it
            if smallerButton || dictionaryHasDefinition {
                Button(buttonText, action: showDictionary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .glassEffect(.regular.tint(smallerButton ? .white : primaryColor).interactive())
                    .foregroundStyle(smallerButton ? secondaryColor : .white)
                .alert("Looking up a word", isPresented: $showingDictionaryExplanationAlert) {
                    Button("Continue") {
                        alreadyUsedDictionary = true
                        showingDictionary = true
                    }
                } message: {
                    Text("Word definitions are provided by the system dictionaries. You can manage your dictionaries from the \"Manage Dictionaries\" button.", comment: "An explanation (shown only once) of the system dictionaries. Make sure the name of the button matches the one displayed by the dictionary view Apple provides.")
                }
                .sheet(isPresented: $showingDictionary) {
                    DictionaryView(term: term)
                        .ignoresSafeArea()
                }
            } else if !smallerButton {    // say that no definition is available, but not in smaller buttons
                Text("No definition available for \"\(term)\".")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        .linearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    init(term: String, primaryColor: Color, secondaryColor: Color, smaller: Bool = false) {
        self.term = term
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.smallerButton = smaller
        
        // UIReferenceLibraryViewController is not available on the Mac
        self.dictionaryHasDefinition =
        if ProcessInfo.processInfo.isiOSAppOnMac { false }
        else if smaller { true }    // behave as if the definition is available (no room to show error), the dictionary itself will show the error if needed
        else {
            UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term)
        }
    }
    
    func showDictionary() {
        guard !term.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        if alreadyUsedDictionary {
            showingDictionary = true
        } else {
            showingDictionaryExplanationAlert = true
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return ShowDictionaryButton(term: Word.example.term, primaryColor: Word.example.primaryColor, secondaryColor: Word.example.secondaryColor)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
