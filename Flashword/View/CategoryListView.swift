//
//  CategoryListView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct CategoryListView: View {
    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
    @State private var showingAddCategorySheet = false
    
    var body: some View {
        List {
            NavigationLink(value: RouterDestination.allWordsCategory) {
                Text("All words")
            }
            
            ForEach(categories) { category in
                NavigationLink(value: RouterDestination.category(category: category)) {
                    VStack(alignment: .leading) {
                        Text(category.name)
                        Text("\(category.words.count) words")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .toolbar {
            Button("Add a new category", systemImage: "plus") {
                showingAddCategorySheet = true
            }
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            AddCategoryView()
        }
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
