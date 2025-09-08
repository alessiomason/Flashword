//
//  ImportExportView.swift
//  Flashword
//
//  Created by Alessio Mason on 06/09/25.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct ImportExportView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingImporter = false
    @State private var errorImporting = false
    
    @State private var showingExporter = false
    @State private var errorExporting = false
    @State private var exportedFile: ExportedDatabase? = nil
    
    @State private var showingDeleteConfirmation = false
    @State private var errorDeleting = false
    
    let defaultFileName = String(localized: "Flashword database")
    
    var body: some View {
        List {
            Section {
                Text("Import and export all words and categories in the app from or to a local JSON file.")
            }
            
            Button {
                showingImporter = true
            } label: {
                Label("Import words and categories", systemImage: "square.and.arrow.down")
            }
            
            Button(action: exportFile) {
                Label("Export words and categories", systemImage: "square.and.arrow.up")
            }
            
            Button {
                showingDeleteConfirmation = true
            } label: {
                Label("Delete all words and categories", systemImage: "trash")
            }
        }
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json], onCompletion: importFile)
        .fileExporter(isPresented: $showingExporter, document: exportedFile, contentType: .json, defaultFilename: defaultFileName) { result in
            switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        .alert("Are you sure you want to delete all data in your app?", isPresented: $showingDeleteConfirmation) {
            Button(role: .cancel) { }
            Button(role: .destructive, action: emptyDatabase)
        } message: {
            Text("If you continue, all words and categories in your app will be permanently deleted. If you haven't previously exported them, you will not be able to recover them in any way.")
        }
        .alert("Import failed", isPresented: $errorImporting) {
        } message: {
            Text("An error occurred while trying to import your data.")
        }
        .alert("Export failed", isPresented: $errorExporting) {
        } message: {
            Text("An error occurred while trying to export your data.")
        }
        .alert("Delete failed", isPresented: $errorDeleting) {
        } message: {
            Text("An error occurred while trying to delete all data from the app.")
        }
        .navigationTitle("Import and export")
    }
    
    private func importFile(_ result: Result<URL, Error>) {
        switch result {
            case .success(let file):
                // gain access to the directory
                let gotAccess = file.startAccessingSecurityScopedResource()
                guard gotAccess else { return }
                
                do {
                    let fileData = try Data(contentsOf: file)
                    let fileJson = String(bytes: fileData, encoding: .utf8)!
                    let importedDatabase = try AppDatabase(from: fileJson)
                    
                    // import categories
                    importedDatabase.categories.forEach { category in
                        modelContext.insert(category)
                    }
                    
                    if modelContext.hasChanges {
                        try modelContext.save()
                    }
                    
                    // import words
                    try importedDatabase.words.forEach { word in
                        var wordCategory: Category? = nil
                        let wordCategoryName = word.category?.name
                        if let wordCategoryName {
                            let descriptor = FetchDescriptor<Category>(predicate: #Predicate { $0.name == wordCategoryName})
                            wordCategory = try modelContext.fetch(descriptor).first
                        }
                        
                        word.category = nil     // saving a new word with a category would duplicate the category
                        modelContext.insert(word)
                        word.category = wordCategory
                    }
                } catch {
                    errorImporting = true
                    return
                }
                
                file.stopAccessingSecurityScopedResource()
            case .failure:
                errorImporting = true
        }
    }
    
    private func exportFile() {
        do {
            let categoriesDescriptor = FetchDescriptor<Category>()
            let categories = try modelContext.fetch(categoriesDescriptor)
            let wordsDescriptor = FetchDescriptor<Word>()
            let words = try modelContext.fetch(wordsDescriptor)
            
            let database = AppDatabase(categories: categories, words: words)
            let encodedDatabase = try database.encode()
            
            exportedFile = ExportedDatabase(initialContent: encodedDatabase)
            showingExporter = true
        } catch {
            errorExporting = true
        }
    }
    
    private func emptyDatabase() {
        do {
            let categoriesDescriptor = FetchDescriptor<Category>()
            let categories = try modelContext.fetch(categoriesDescriptor)
            let wordsDescriptor = FetchDescriptor<Word>()
            let words = try modelContext.fetch(wordsDescriptor)
            
            for word in words {
                modelContext.delete(word)
            }
            for category in categories {
                modelContext.delete(category)
            }
            
            if modelContext.hasChanges {
                try modelContext.save()
            }
        } catch {
            errorDeleting = true
        }
    }
}

#Preview {
    ImportExportView()
}
