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
            AppFeatureBoxView(systemImageName: "books.vertical", title: "Words", subtitle: "Save words, look up their definitions, and more!")
                .padding(.top, 32)
                .padding(.horizontal, 8)
            
            AppFeatureBoxView(systemImageName: "folder", title: "Categories", subtitle: "Create custom categories to organize your words!")
                .padding(.horizontal, 8)
            
            AppFeatureBoxView(systemImageName: "questionmark.text.page", title: "Quizzes", subtitle: "Test you knowledge with fun quizzes generated with Apple Intelligence!")
                .padding(.horizontal, 8)
            
            AppFeatureBoxView(systemImageName: "icloud", title: "System integration", subtitle: "Use the app at its best with Spotlight integration, iCloud syncing, and more!")
                .padding(.horizontal, 8)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AppPresentationView()
}
