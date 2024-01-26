//
//  AddCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Category name", text: $name)
            }
            .navigationTitle("Add a new category")
            .toolbar {
                Button("Add") {
                    let category = Category(name: name, primaryColor: ColorComponents(color: .mint), secondaryColor: ColorComponents(color: .blue))
                    modelContext.insert(category)
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    AddCategoryView()
}
