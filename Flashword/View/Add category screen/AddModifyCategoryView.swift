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
    @Environment(\.self) private var environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoryToBeModified: Category?
    var modifying: Bool {
        categoryToBeModified != nil
    }
    
    @State private var name = ""
    @State private var showingDuplicateCategoryAlert = false
    @State private var selectedColorChoiceId = 0
    private var selectedColorChoice: ColorChoice {
        ColorChoice.choices[selectedColorChoiceId] ?? ColorChoice.choices[0]!
    }
    // the previously selected symbol, to be shown in the suggested symbols list even if the current one changes
    @State private var previouslySelectedSymbol = Symbol.suggested[0]
    @State private var selectedSymbol = Symbol.suggested[0]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category's name", text: $name)
                } footer: {
                    Text("The name has to be unique across all categories: let's not get you confused :)", comment: "The text inviting the user to enter a unique name for the new category")
                }
                
                Section("Category color") {
                    ChooseColorView(selectedColorChoiceId: $selectedColorChoiceId)
                }
                
                Section("Symbol for the category") {
                    ChooseHighlightedSymbolView(selectedColorChoice: selectedColorChoice, previouslySelectedSymbol: previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
                    
                    NavigationLink("More symbols…") {
                        ChooseSymbolView(selectedColorChoice: selectedColorChoice, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
                    }
                }
            }
            .navigationTitle(modifying ? "Edit the category" : "Insert a new category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply.circle") {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button {
                        if modifying {
                            updateCategory()
                        } else {
                            insertNewCategory()
                        }
                    } label: {
                        Text(modifying ? "Save" : "Add")
                            .bold()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
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
            
            self._selectedColorChoiceId = State(initialValue: category.colorChoiceId)
            self._previouslySelectedSymbol = State(initialValue: category.symbol)
            self._selectedSymbol = State(initialValue: category.symbol)
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
        
        if duplicatesCount == 0  {
            let category = Category(name: name, colorChoiceId: selectedColorChoice.id, symbol: selectedSymbol)
            modelContext.insert(category)
            dismiss()
        } else {
            showingDuplicateCategoryAlert = true
        }
    }
    
    func updateCategory() {
        guard let categoryToBeModified else { fatalError("Missing category to be modified.") }
        
        // if changing name, check that no duplicates exist
        let duplicatesCount = categoryToBeModified.name != name ? fetchDuplicates() : 0
        
        if duplicatesCount == 0 || duplicatesCount == nil {
            categoryToBeModified.name = name
            categoryToBeModified.colorChoiceId = selectedColorChoice.id
            categoryToBeModified.symbol = selectedSymbol
            
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
