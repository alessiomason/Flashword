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
    let smallerButton: Bool
    let onWhiteBackground: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("alreadyUsedDictionary") private var alreadyUsedDictionary = false
    @State private var showingDictionaryExplanationAlert = false
    @State private var showingDictionary = false
    
    private var buttonText: String {
        if smallerButton {
            String(localized: "Look up")
        } else {
            String(localized: "Look up word")
        }
    }
    
    private var buttonTextColor: Color {
        if !onWhiteBackground {
            return secondaryColor
        }
        
        return if smallerButton {
            primaryColor
        } else {
            .white
        }
    }
    
    private var buttonBackgroundColor: Color {
        if !onWhiteBackground {
            return primaryColor
        }
        
        if smallerButton {
            return if colorScheme == .dark {
                .gray.opacity(0.25)
            } else {
                .white
            }
        }
        
        return primaryColor
    }
    
    private var noDefinitionColor: some ShapeStyle {
        if onWhiteBackground {
            AnyShapeStyle(LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing))
        } else {
            AnyShapeStyle(Color.white)
        }
    }
    
    var body: some View {
        // UIReferenceLibraryViewController is not available on the Mac, so don't show the button altogether
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            // smaller button is used for text fields, so avoid button appearing and disappearing as the
            // user types, always show it
            if smallerButton || dictionaryHasDefinition {
                Button(action: showDictionary) {
                    Text(buttonText)
                        .foregroundStyle(buttonTextColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                }
                .tint(buttonBackgroundColor)
                .buttonStyle(.glassProminent)
                .padding(.vertical, 6)
                .padding(.horizontal, 4)
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
                    .foregroundStyle(noDefinitionColor)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    init(term: String, primaryColor: Color, secondaryColor: Color, smaller: Bool = false, onWhiteBackground: Bool = true) {
        self.term = term
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.smallerButton = smaller
        self.onWhiteBackground = onWhiteBackground
        
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
        
        return ShowDictionaryButton(term: Word.example.term, primaryColor: Word.example.primaryColor, secondaryColor: Word.example.secondaryColor, smaller: true)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
