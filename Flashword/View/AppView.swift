//
//  AppView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftData
import SwiftUI

struct AppView: View {
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            WordsCardsListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .navigationDestination(for: Word.self) { word in
                    WordView(word: word)
                }
        }
        .environment(router)
    }
}

#Preview {
    AppView()
}
