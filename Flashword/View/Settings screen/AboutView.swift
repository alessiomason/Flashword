//
//  AboutView.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftUI
import WebKit

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    @ScaledMetric private var iconHeight = 20.0
    
    let personalDescription = String(localized: """
Hi! My name is Alessio and I am a computer engineer from Italy! 🇮🇹
I am a high school teacher, but I like creating apps from time to time!
This is the first app I develop, thank you so very much for even just trying it out!
Below you can find some links to follow me online!
""")
    
    var body: some View {
        List {
            Section {
                VStack {
                    PicturesSectionView()
                    
                    Text(personalDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section("Follow me online") {
                Link(destination: URL(string: "https://www.alessiomason.it")!) {
                    Label("Personal website", systemImage: "person")
                }
                
                Link(destination: URL(string: "https://mastodon.social/@alemason")!) {
                    Label {
                        Text("Mastodon profile")
                    } icon: {
                        Image(.mastodon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: iconHeight)
                            .blendingHorizontally(color: .blue)
                    }
                }
                
                Link(destination: URL(string: "https://github.com/alessiomason")!) {
                    Label {
                        Text("GitHub profile")
                    } icon: {
                        Image(.gitHub)
                            .resizable()
                            .scaledToFit()
                            .frame(height: iconHeight)
                            .blendingHorizontally(color: .blue)
                    }
                }
            }
            
            Section {
                NavigationLink {
                    OnboardingView()
                        .navigationTitle("Flashword")
                } label: {
                    HStack {
                        Image(.flashwordIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                        
                        VStack(alignment: .leading) {
                            Text("Flashword's features and the latest update")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Discover Flashword and the features of the latest update")
                                .font(.subheadline)
                        }
                        .padding(.leading, 10)
                        .foregroundStyle(.blue)
                    }
                }
                
                Link(destination: URL(string: "https://www.alessiomason.it/apps/flashword")!) {
                    Label("Flashword's website", systemImage: "globe")
                }
                
                Link(destination: URL(string: "https://github.com/alessiomason/Flashword")!) {
                    Label {
                        Text("Flashword's repository")
                    } icon: {
                        Image(.gitHub)
                            .resizable()
                            .scaledToFit()
                            .frame(height: iconHeight)
                            .blendingHorizontally(color: .blue)
                    }
                }
            } header: {
                Text("Follow the app development")
            } footer: {
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("App version: \(appVersion)")
                }
            }
            
            Section {
                NavigationLink {
                    WebView(url: URL(string: "https://www.alessiomason.it/apps/flashword/terms-of-use")!)
                        .navigationTitle("Terms of use")
                } label: {
                    Label("Terms of use", systemImage: "doc.text.magnifyingglass")
                }
                .foregroundStyle(.blue)
                
                NavigationLink {
                    WebView(url: URL(string: "https://www.alessiomason.it/apps/flashword/privacy-policy")!)
                        .navigationTitle("Privacy policy")
                } label: {
                    Label("Privacy policy", systemImage: "lock")
                }
                .foregroundStyle(.blue)
                
                Link(destination: URL(string: "mailto:alessiomason99@gmail.com")!) {
                    Label("Contact me", systemImage: "paperplane")
                }
            } header: {
                Text("About Flashword")
            } footer: {
                Text("Feel free to contact me for any comment, suggestion or problem you might have!")
            }
        }
        .navigationTitle("About Flashword")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
