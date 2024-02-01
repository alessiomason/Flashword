//
//  AboutView.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftUI

struct AboutView: View {
    let personalDescription = String(localized: """
Hi! My name is Alessio and I am a computer engineer from Italy 🇮🇹!
This is the first app I develop, thank you so very much for even just trying it out!
Below you can find some links to follow me online!
""")
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .top) {
                        Image("Alessio 2021")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                            .clipShape(.circle)
                            .padding(.trailing, 10)
                        
                        Text(personalDescription)
                    }
                }
                
                Section("Follow me online") {
                    Link(destination: URL(string: "https://www.alessiomason.it")!) {
                        HStack {
                            Image(systemName: "globe")
                            
                            Text("Personal website")
                        }
                    }
                    
                    Link(destination: URL(string: "https://mastodon.social/@alemason")!) {
                        HStack {
                            Image("Mastodon")
                                .frame(width: 20)
                                .blendingHorizontally(color: .blue)
                            
                            Text("Mastodon profile")
                        }
                    }
                    
                    Link(destination: URL(string: "https://github.com/alessiomason")!) {
                        HStack {
                            Image("GitHub")
                                .frame(width: 20)
                                .blendingHorizontally(color: .blue)
                            
                            Text("GitHub profile")
                        }
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/alessiomason")!) {
                        HStack {
                            Image("GitHub")
                                .frame(width: 20)
                                .blendingHorizontally(color: .gray)
                            
                            Text("Flashword repository")
                        }
                    }
                    .disabled(true)
                } header: {
                    Text("Follow the app development")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("I will soon publish the repository containing the source code for this app on my GitHub profile!")
                            .padding(.bottom, 5)
                        
                        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("App version: \(appVersion)")
                        }
                    }
                }
            }
            .navigationTitle("About Flashword")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AboutView()
}