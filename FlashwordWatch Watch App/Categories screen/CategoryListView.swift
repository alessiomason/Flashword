//
//  CategoryListView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct CategoryListView: View {
    @Query(sort: Category.sortDescriptors) private var categories: [Category]
    
    var body: some View {
        List {
            Section {
                NavigationLink(value: RouterDestination.allWordsCategory) {
                    Label {
                        Text("All words")
                    } icon: {
                        Image(systemName: "books.vertical")
                            .foregroundStyle(.blue)
                    }
                }
                NavigationLink(value: RouterDestination.bookmarksCategory) {
                    Label {
                        Text("Bookmarks")
                    } icon: {
                        Image(systemName: "bookmark")
                            .foregroundStyle(.blue)
                    }
                }
                NavigationLink(value: RouterDestination.recentlyAddedCategory()) {
                    Label {
                        Text("Recently added")
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundStyle(.blue)
                    }
                }
            }
            
            if !categories.isEmpty {
                Section("Categories") {
                    ForEach(categories) { category in
                        NavigationLink(value: RouterDestination.category(category: category)) {
                            CategoryListItemView(category: category)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryListView()
}
