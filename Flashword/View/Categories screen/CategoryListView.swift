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
    @Environment(Router.self) private var router
    @Environment(\.editMode) private var editMode
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
    
    @State private var showingSettingsScreen = false
    @State private var showingAddCategorySheet = false
    @State private var categoryToBeModified: Category? = nil
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(value: RouterDestination.allWordsCategory) {
                    Label {
                        Text("All words")
                    } icon: {
                        Image(systemName: "books.vertical")
                            .foregroundStyle(router.tintColor ?? .blue)
                    }
                }
                NavigationLink(value: RouterDestination.bookmarksCategory) {
                    Label {
                        Text("Bookmarks")
                    } icon: {
                        Image(systemName: "bookmark")
                            .foregroundStyle(router.tintColor ?? .blue)
                    }
                }
                NavigationLink(value: RouterDestination.recentlyAddedCategory()) {
                    Label {
                        Text("Recently added")
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundStyle(router.tintColor ?? .blue)
                    }
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
                                deleteCategory(category: category)
                            } label: {
                                Label("Delete category", systemImage: "trash")
                                    .tint(Color.red)
                            }
                            
                            Button {
                                categoryToBeModified = category
                            } label: {
                                Label("Edit category", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: deleteCategories)
                }
            } else {
                NoCategoriesView(showingAddCategorySheet: $showingAddCategorySheet)
            }
        }
        .toolbar {
            if !categories.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .tint(router.tintColor)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("About Flashword", systemImage: "gear") {
                    showingSettingsScreen = true
                }
                .tint(router.tintColor)
                .disabled(isEditing)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Insert a new category", systemImage: "plus") {
                    showingAddCategorySheet = true
                }
                .tint(router.tintColor)
                .disabled(isEditing)
            }
        }
        .sheet(isPresented: $showingSettingsScreen) {
            SettingsView()
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            AddModifyCategoryView()
        }
        .sheet(item: $categoryToBeModified) { category in
            AddModifyCategoryView(category: category)
        }
    }
    
    func deleteCategory(category: Category) {
        modelContext.delete(category)
    }
    
    func deleteCategories(at offsets: IndexSet) {
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
