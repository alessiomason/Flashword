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
            CategoryListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .navigationDestination(for: RouterDestination.self) { destination in
                    switch destination {
                        case .allWordsCategory:
                            AllWordsCategoryView()
                        case let .category(category):
                            CategoryView(category: category)
                        case let .word(word):
                            WordView(word: word)
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    AppView()
}
