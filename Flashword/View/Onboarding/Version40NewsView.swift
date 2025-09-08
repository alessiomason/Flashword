//
//  Version40NewsView.swift
//  Flashword
//
//  Created by Alessio Mason on 06/09/25.
//

import SwiftUI

struct Version40NewsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AppFeatureBoxView(title: "A whole new look", subtitle: "The entire app has been redesigned for Liquid Glass and the new system look!", imageWeight: .regular) {
                    Image(.liquidGlass)
                }
                .padding(.top, 32)
                .padding(.horizontal, 8)
                
                AppFeatureBoxView(title: "Quizzes", subtitle: "Test you knowledge with fun quizzes generated with Apple Intelligence!", imageWeight: .light) {
                    Image(systemName: "questionmark.text.page")
                }
                .padding(.horizontal, 8)
                
                AppFeatureBoxView(title: "Search", subtitle: "A dedicated tab for searching words and categories!", imageWeight: .light) {
                    Image(systemName: "magnifyingglass")
                }
                .padding(.horizontal, 8)
                
                AppFeatureBoxView(title: "Import and export words and categories", subtitle: "Safely back up and restore your data by importing and exporting words and categories outside the app!", imageWeight: .regular) {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding(.horizontal, 8)
                
                AppFeatureBoxView(title: "Many optimizations and fixes", subtitle: "Many bugs fixed and many improvements around the app!", imageWeight: .regular) {
                    Image(systemName: "wrench.adjustable")
                }
                .padding(.horizontal, 8)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Version40NewsView()
}
