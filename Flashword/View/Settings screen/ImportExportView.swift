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
    @State private var exportedFile: ExportedDatabase? = nil
    
    @State private var errorDeleting = false
    
    let defaultFileName = String(localized: "Flashword database")
    
    var body: some View {
        List {
            Button("Import") {
                showingImporter = true
            }
            
            Button("Export", action: exportFile)
            
            Button("Delete", action: emptyDatabase)
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
        .alert("Failed to delete all data", isPresented: $errorDeleting) {
        } message: {
            Text("An error occured while trying to delete all data from the app.")
        }
        
    }
    
    private func importFile(_ result: Result<URL, Error>) {
        switch result {
            case .success(let file):
                // gain access to the directory
                let gotAccess = file.startAccessingSecurityScopedResource()
                guard gotAccess else { return }
                
                do {
                    let fileData = try Data(contentsOf: file)
                    guard let fileJson = String(bytes: fileData, encoding: .utf8) else { errorImporting = true; return }
                    let importedDatabase = try AppDatabase(from: fileJson)
                    
                    // import categories
                    importedDatabase.categories.forEach { category in
                        modelContext.insert(category)
                    }
                    try? modelContext.save()
                    
                    // import words
                    importedDatabase.words.forEach { word in
                        var wordCategory: Category? = nil
                        let wordCategoryName = word.category?.name
                        if let wordCategoryName {
                            let descriptor = FetchDescriptor<Category>(predicate: #Predicate { $0.name == wordCategoryName})
                            wordCategory = try? modelContext.fetch(descriptor).first
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
            case .failure(let error):
                // TODO: handle error
                print(error)
        }
    }
    
    private func exportFile() {
        let categoriesDescriptor = FetchDescriptor<Category>()
        guard let categories = try? modelContext.fetch(categoriesDescriptor) else { return }
        let wordsDescriptor = FetchDescriptor<Word>()
        guard let words = try? modelContext.fetch(wordsDescriptor) else { return }
        
        let database = AppDatabase(categories: categories, words: words)
        
        guard let encodedDatabase = try? database.encode() else { return }
        
        exportedFile = ExportedDatabase(initialContent: encodedDatabase)
        showingExporter = true
    }
    
    private func emptyDatabase() {
        do {
            try modelContext.container.erase()
        } catch {
            errorDeleting = true
        }
    }
}

#Preview {
    ImportExportView()
}
