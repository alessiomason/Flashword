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
    
    var body: some View {
        NavigationStack {
            List {
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
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Discover more about Flashword and its creator!")
                                .font(.footnote)
                        }
                        .padding(.leading, 8)
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