//
//  AddCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

struct AddCategoryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var showingDuplicateCategoryAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category's name", text: $name)
                } footer: {
                    Text("The name has to be unique across all categories: let's not get you confused :)", comment: "The text inviting the user to enter a unique name for the new category")
                }
            }
            .navigationTitle("Add a new category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add", action: insertNewCategory)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .alert("Cannot create a duplicate category!", isPresented: $showingDuplicateCategoryAlert) {
                Button("OK") { }
            } message: {
                Text("A category named \"\(name)\" already exists!")
            }

        }
    }
    
    func insertNewCategory() {
        // check if a category with the same name is already present
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { category in
                category.name == name
            }
        )
        let duplicatesCount = try? modelContext.fetchCount(descriptor)
        
        // if duplicatesCount is nil the query was not successful, however I still insert the category:
        // SwiftData will still make sure that the category's name is unique and will ignore duplicates.
        // Throwing an error if this query fails did not seem necessary (thanks to SwiftData still
        // handling everything correctly, albeit transparently to the user)
        if duplicatesCount == 0 || duplicatesCount == nil {
            let category = Category(name: name, primaryColor: ColorComponents(color: .mint), secondaryColor: ColorComponents(color: .blue))
            modelContext.insert(category)
            dismiss()
        } else {
            showingDuplicateCategoryAlert = true
        }
    }
}

#Preview {
    AddCategoryView()
}
