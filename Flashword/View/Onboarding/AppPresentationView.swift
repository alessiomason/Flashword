//
//  AppPresentationView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

struct AppPresentationView: View {
    @ScaledMetric private var iconHeight = 60.0
    
    var body: some View {
        VStack(alignment: .leading) {
            AppFeatureBoxView(title: "Words", subtitle: "Save words, look up their definitions, and more!", imageWeight: .regular) {
                Image(systemName: "books.vertical")
            }
            .padding(.top, 32)
            .padding(.horizontal, 8)
            
            AppFeatureBoxView(title: "Categories", subtitle: "Create custom categories to organize your words!", imageWeight: .regular) {
                Image(systemName: "folder")
            }
            .padding(.horizontal, 8)
            
            AppFeatureBoxView(title: "Quizzes", subtitle: "Test you knowledge with fun quizzes generated with Apple Intelligence!", imageWeight: .light) {
                Image(systemName: "questionmark.text.page")
            }
            .padding(.horizontal, 8)
            
            AppFeatureBoxView(title: "System integration", subtitle: "Use the app at its best with Spotlight integration, iCloud syncing, and more!", imageWeight: .regular) {
                Image(systemName: "icloud")
            }
            .padding(.horizontal, 8)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AppPresentationView()
}
