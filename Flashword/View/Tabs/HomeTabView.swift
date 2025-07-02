//
//  HomeTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 02/07/25.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private(set) var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CategoryListView()
                .navigationTitle(Text("Flashword", comment: "The name of the app"))
                .withRouterDestinations(modelContext: modelContext)
        }
        .environment(router)
    }
}

#Preview {
    HomeTabView()
}
