//
//  AddCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 26/01/24.
//

import SwiftData
import SwiftUI

/// If a category is passed in, it will be used to initialize the field and the View will modify said category. Otherwise, a new category will be created.
struct AddModifyCategoryView: View {
    @Environment(\.self) var environment
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var categoryToBeModified: Category?
    var modifying: Bool {
        categoryToBeModified != nil
    }
    
    @State private var name = ""
    @State private var showingDuplicateCategoryAlert = false
    @State private var selectedColorChoice: ColorChoice = ColorChoice.choices[0]
    
    let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category's name", text: $name)
                } footer: {
                    Text("The name has to be unique across all categories: let's not get you confused :)", comment: "The text inviting the user to enter a unique name for the new category")
                }
                
                Section("Category color") {
                    LazyVGrid(columns: columns) {
                        ForEach(ColorChoice.choices) { colorChoice in
                            Button {
                                selectedColorChoice = colorChoice
                            } label: {
                                ZStack {
                                    ColorCircle(primaryColor: colorChoice.primaryColor, secondaryColor: colorChoice.secondaryColor)
                                        .frame(width: 60)
                                    
                                    if colorChoice == selectedColorChoice {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25)
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(modifying ? "Modify the category" : "Insert a new category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply.circle") {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button(modifying ? "Save" : "Add") {
                        if modifying {
                            updateCategory()
                        } else {
                            insertNewCategory()
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Cannot create a duplicate category!", isPresented: $showingDuplicateCategoryAlert) {
                Button("OK") { }
            } message: {
                Text("A category named \"\(name)\" already exists!")
            }

        }
    }
    
    init(category: Category? = nil) {
        self._categoryToBeModified = State(initialValue: category)
        
        if let category {
            self._name = State(initialValue: category.name)
            
            let colorChoice = ColorChoice.choices.first { colorChoice in
                colorChoice.id == category.colorChoiceId
            }
            self._selectedColorChoice = State(initialValue: colorChoice ?? ColorChoice.choices[0])
        }
    }
    
    /// Checks if a category with the same name is already present.
    func fetchDuplicates() -> Int? {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { category in
                category.name == name
            }
        )
        return try? modelContext.fetchCount(descriptor)
    }
    
    func insertNewCategory() {
        let duplicatesCount = fetchDuplicates()
        
        // if duplicatesCount is nil the query was not successful, however I still insert the category:
        // SwiftData will still make sure that the category's name is unique and will ignore duplicates.
        // Throwing an error if this query fails did not seem necessary (thanks to SwiftData still
        // handling everything correctly, albeit transparently to the user)
        if duplicatesCount == 0 || duplicatesCount == nil {
            let resolvedPrimaryColor = selectedColorChoice.primaryColor.resolve(in: environment)
            let resolvedSecondaryColor = selectedColorChoice.secondaryColor.resolve(in: environment)
            let primaryColorComponents = ColorComponents(resolvedColor: resolvedPrimaryColor)
            let secondaryColorComponents = ColorComponents(resolvedColor: resolvedSecondaryColor)
            
            let category = Category(name: name, primaryColorComponents: primaryColorComponents, secondaryColorComponents: secondaryColorComponents, colorChoiceId: selectedColorChoice.id)
            modelContext.insert(category)
            dismiss()
        } else {
            showingDuplicateCategoryAlert = true
        }
    }
    
    func updateCategory() {
        guard let categoryToBeModified else { fatalError("Missing category to be modified.") }
        
        // if changing name, check that no duplicates exist
        print(categoryToBeModified.name)
        print(name)
        let duplicatesCount = categoryToBeModified.name != name ? fetchDuplicates() : 0
        
        if duplicatesCount == 0 || duplicatesCount == nil {
            categoryToBeModified.name = name
            categoryToBeModified.colorChoiceId = selectedColorChoice.id
            
            let resolvedPrimaryColor = selectedColorChoice.primaryColor.resolve(in: environment)
            let resolvedSecondaryColor = selectedColorChoice.secondaryColor.resolve(in: environment)
            let primaryColorComponents = ColorComponents(resolvedColor: resolvedPrimaryColor)
            let secondaryColorComponents = ColorComponents(resolvedColor: resolvedSecondaryColor)
            categoryToBeModified.primaryColorComponents = primaryColorComponents
            categoryToBeModified.secondaryColorComponents = secondaryColorComponents
            
            dismiss()
        } else {
            showingDuplicateCategoryAlert = true
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        container.mainContext.insert(Category.otherExample)
        
        return NavigationStack {
            AddModifyCategoryView(category: .otherExample)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
