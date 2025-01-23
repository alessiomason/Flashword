//
//  SettingsView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/12/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("spotlightEnabled") private var spotlightEnabled = true
    
    @ScaledMetric private var iconHeight = 35.0
    @AppStorage("defaultColorChoiceId") private var defaultColorChoiceId = 0
    private var defaultColorChoice: ColorChoice {
        ColorChoice.choices[defaultColorChoiceId] ?? ColorChoice.choices[0]!
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            Image(.flashwordIcon)
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { width, axis in
                                    width * 0.25
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            VStack(alignment: .leading) {
                                Text("About Flashword")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("Discover more about Flashword and its creator!")
                                    .font(.subheadline)
                            }
                            .padding(.leading, 8)
                        }
                    }
                    
                    NavigationLink {
                        TipJarView()
                    } label: {
                        HStack {
                            Text("🍯")
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text("Tip jar").bold()
                                Text("Support the development")
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                
                Section {
                    Toggle("Spotlight integration", isOn: $spotlightEnabled)
                        .onChange(of: spotlightEnabled, handleSpotlightIntegration)
                } header: {
                    Text("Spotlight")
                } footer: {
                    if spotlightEnabled {
                        Text("Spotlight integration is currently enabled: every word you create is indexed and can appear in your search results outside the app.")
                    } else {
                        Text("Spotlight integration is currently disabled. If you enable it, every word you create is indexed and can appear in your search results outside the app.")
                    }
                }
                
                Section {
                    NavigationLink {
                        DefaultColorView()
                    } label: {
                        HStack {
                            ColorCircle(primaryColor: defaultColorChoice.primaryColor, secondaryColor: defaultColorChoice.secondaryColor)
                                .padding(.vertical, 4)
                                .padding(.trailing, 4)
                                .frame(maxWidth: iconHeight, maxHeight: iconHeight)
                            
                            Text("Uncategorized words color")
                        }
                    }
                } header: {
                    Text("Uncategorized words")
                } footer: {
                    Text("Choose the color for the words that do not belong to a specific category.")
                }
                
                Section("System dictionaries") {
                    NavigationLink("How to manage your dictionaries") {
                        DictionariesExplanationView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply.circle") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func handleSpotlightIntegration() {
        if spotlightEnabled {
            indexWords(modelContext: modelContext)
        } else {
            deleteSpotlightIndex(modelContext: modelContext)
        }
    }
}

#Preview {
    SettingsView()
}
