//
//  AboutView.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftUI

struct AboutView: View {
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
                    HStack {
                        Image(.alessio2021)
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { width, axis in
                                width * 0.25
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 8)
                        
                        Image(.flashwordIcon)
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { width, axis in
                                width * 0.25
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 8)
                    }
                    .padding(.bottom, 8)
                    
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
                Link(destination: URL(string: "https://www.alessiomason.it/apps/flashword/terms-of-use")!) {
                    Label("Terms of use", systemImage: "doc.text.magnifyingglass")
                }
                
                Link(destination: URL(string: "https://www.alessiomason.it/apps/flashword/privacy-policy")!) {
                    Label("Privacy policy", systemImage: "lock")
                }
                
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
    AboutView()
}
