//
//  CategoryListView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct CategoryListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.editMode) var editMode
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
    @State private var showingAddCategorySheet = false
    
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
            
            Section("Categories") {
                ForEach(categories) { category in
                    NavigationLink(value: RouterDestination.category(category: category)) {
                        VStack(alignment: .leading) {
                            Text(category.name)
                            Text("\(category.words.count) words")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: removeCategories)
            }
        }
        .toolbar {
            if !categories.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add a new category", systemImage: "plus") {
                    showingAddCategorySheet = true
                }
                .disabled(isEditing)
            }
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            AddCategoryView()
        }
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
            Category(name: "Example", primaryColor: ColorComponents(color: .mint), secondaryColor: ColorComponents(color: .blue))
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
