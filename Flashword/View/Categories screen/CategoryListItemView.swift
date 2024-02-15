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
                .padding(.vertical, 8)
                .padding(.trailing, 8)
                .fixedSize(horizontal: true, vertical: false)
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundStyle(category.secondaryColor)
                Text("\(category.words.count) words")
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
