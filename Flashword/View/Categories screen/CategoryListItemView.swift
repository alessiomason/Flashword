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
    
    var body: some View {
        HStack {
            CategoryIcon(category: category)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundStyle(category.tintColor)
                Text("\(category.unwrappedWords.count) words")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
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
