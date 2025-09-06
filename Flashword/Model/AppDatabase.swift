//
//  ExportedDatabase.swift
//  Flashword
//
//  Created by Alessio Mason on 06/09/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct AppDatabase: Codable {
    let categories: [Category]
    let words: [Word]
    
    init(categories: [Category], words: [Word]) {
        self.categories = categories
        self.words = words
    }
    
    init(from json: String) throws {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(AppDatabase.self, from: data)
    }
    
    func encode() throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let encodedDatabase = try encoder.encode(self)
        return String(data: encodedDatabase, encoding: .utf8)!
    }
}

struct ExportedDatabase: FileDocument {
    static var readableContentTypes = [UTType.json]
    
    var content = ""
    
    init(initialContent: String = "") {
        content = initialContent
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            content = String(decoding: data, as: UTF8.self)
        }
    }
    
    // this will be called when the system wants to write data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
