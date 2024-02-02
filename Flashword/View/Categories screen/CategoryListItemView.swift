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
    
    var body: some View {
        HStack {
            ColorCircle(primaryColor: primaryColor, secondaryColor: secondaryColor)
                .padding(.vertical, 8)
                .padding(.trailing, 8)
                .fixedSize(horizontal: true, vertical: false)
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundStyle(secondaryColor)
                Text("\(category.words.count) words")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    init(category: Category) {
        self.category = category
        self.primaryColor = Color(colorComponents: category.primaryColorComponents)
        self.secondaryColor = Color(colorComponents: category.secondaryColorComponents)
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
