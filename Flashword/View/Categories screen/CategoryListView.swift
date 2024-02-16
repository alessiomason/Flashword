//
//  CategoryListView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct CategoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
    
    @State private var showingAboutScreen = false
    @State private var showingAddCategorySheet = false
    @State private var categoryToBeModified: Category? = nil
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(value: RouterDestination.allWordsCategory) {
                    Text("All words")
                }
            }
            
            if !categories.isEmpty {
                Section("Categories") {
                    ForEach(categories) { category in
                        NavigationLink(value: RouterDestination.category(category: category)) {
                            CategoryListItemView(category: category)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                removeCategory(category: category)
                            } label: {
                                Label("Delete category", systemImage: "trash")
                            }
                            
                            Button {
                                categoryToBeModified = category
                            } label: {
                                Label("Modify category", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: removeCategories)
                }
            } else {
                NoCategoriesView(showingAddCategorySheet: $showingAddCategorySheet)
            }
        }
        .toolbar {
            if !categories.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("About Flashword", systemImage: "info.circle") {
                    showingAboutScreen = true
                }
                .disabled(isEditing)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Insert a new category", systemImage: "plus") {
                    showingAddCategorySheet = true
                }
                .disabled(isEditing)
            }
        }
        .sheet(isPresented: $showingAboutScreen) {
            AboutView()
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            AddModifyCategoryView()
        }
        .sheet(item: $categoryToBeModified) { category in
            AddModifyCategoryView(category: category)
        }
    }
    
    func removeCategory(category: Category) {
        modelContext.delete(category)
    }
    
    func removeCategories(at offsets: IndexSet) {
        offsets
            .map { categories[$0] }
            .forEach { modelContext.delete($0) }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        let categories = [
            Category.example,
            Category.otherExample
        ]
        
        categories.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            CategoryListView()
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
