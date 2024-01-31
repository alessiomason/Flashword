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
    
    @State private var showingAddCategorySheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        word.category = nil
                        dismiss()
                    } label: {
                        SelectableCategoryListItemView(category: nil, selected: word.category == nil)
                    }
                    
                    ForEach(categories) { category in
                        Button {
                            word.category = category
                            dismiss()
                        } label: {
                            SelectableCategoryListItemView(category: category, selected: word.category == category)
                        }
                    }
                }
                
                Section {
                    Button("Add a new category") {
                        showingAddCategorySheet = true
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Change category of \"\(word.term)\"")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddCategorySheet) {
                AddCategoryView()
            }
        }
    }
}

struct SelectableCategoryListItemView: View {
    let category: Category?
    let selected: Bool
    
    var body: some View {
        HStack {
            if let category {
                CategoryListItemView(category: category)
            } else {
                Text("No category")
            }
            
            Spacer()
            
            if selected {
                Image(systemName: "checkmark")
            }
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
