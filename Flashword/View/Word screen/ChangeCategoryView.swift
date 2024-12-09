//
//  ChangeCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 27/01/24.
//

import SwiftData
import SwiftUI

struct ChangeCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
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
                            word.index()
                            dismiss()
                        } label: {
                            SelectableCategoryListItemView(category: category, selected: word.category == category)
                        }
                        .tint(category.primaryColor)
                    }
                }
                
                Section {
                    Button("Insert a new category") {
                        showingAddCategorySheet = true
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Change category of \"\(word.term)\"")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddCategorySheet) {
                AddModifyCategoryView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply.circle") {
                        dismiss()
                    }
                }
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
