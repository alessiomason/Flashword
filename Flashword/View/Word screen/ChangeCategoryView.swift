//
//  ChangeCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 27/01/24.
//

import SwiftData
import SwiftUI

struct ChangeCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: Category.sortDescriptors) var categories: [Category]
    let word: Word
    
    /// All categories but current one.
    var filteredCategories: [Category] {
        categories.filter { category in
            category != word.category
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Word: \(word.term)")
                        .font(.title3)
                        .fontWeight(.medium)
                    Text("Current category: \(word.categoryName)")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                List {
                    if word.category != nil {
                        Button("No category") {
                            word.category = nil
                            dismiss()
                        }
                    }
                    
                    ForEach(filteredCategories) { category in
                        Button(category.name) {
                            word.category = category
                            dismiss()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .navigationTitle("Change category")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        container.mainContext.insert(Category.example)
        container.mainContext.insert(Category.otherExample)
        
        return ChangeCategoryView(word: .example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
