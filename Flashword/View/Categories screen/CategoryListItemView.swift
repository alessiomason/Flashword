//
//  CategoryListItemView.swift
//  Flashword
//
//  Created by Alessio Mason on 31/01/24.
//

import SwiftData
import SwiftUI

struct CategoryListItemView: View {
    let category: Category
    let primaryColor: Color
    let secondaryColor: Color
    
    init(category: Category) {
        self.category = category
        self.primaryColor = Color(colorComponents: category.primaryColor)
        self.secondaryColor = Color(colorComponents: category.secondaryColor)
    }
    
    var body: some View {
        NavigationLink(value: RouterDestination.category(category: category)) {
            HStack {
                ColorCircle(primaryColor: primaryColor, secondaryColor: secondaryColor)
                    .padding(.vertical, 8)
                    .padding(.trailing, 8)
                    .fixedSize(horizontal: true, vertical: false)
                
                VStack(alignment: .leading) {
                    Text(category.name)
                        .foregroundStyle(secondaryColor)
                    Text("\(category.words.count) words")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct ColorCircle: View {
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(
                LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .shadow(radius: 4)
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 3)
            }
    }
}

#Preview("CategoryListItemView") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return NavigationStack {
            List {
                CategoryListItemView(category: .example)
            }
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}

#Preview("ColorCircle") {
    ColorCircle(primaryColor: .mint, secondaryColor: .blue)
}
