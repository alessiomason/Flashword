//
//  Word.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI
import SwiftData

@Model
class Word: Codable {
    enum CodingKeys: CodingKey {
        case term, learntOn, notes, category
    }
    
    let term: String = ""
    let learntOn: Date = Date.now
    var notes: String = ""
    @Relationship(inverse: \Category.words) var category: Category?
    
    var categoryName: String {
        let localizedNoCategory = String(localized: "No category", comment: "The text to display in absence of a user-defined category")
        return category?.name ?? localizedNoCategory
    }
    
    var primaryColor: Color {
        category?.primaryColor ?? .mint
    }
    var secondaryColor: Color {
        category?.secondaryColor ?? .blue
    }
    
    init(term: String, learntOn: Date, notes: String = "", category: Category? = nil) {
        self.term = term
        self.learntOn = learntOn
        self.notes = notes
        self.category = category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.term = try container.decode(String.self, forKey: .term)
        let learntOn = try container.decode(String.self, forKey: .learntOn)
        self.learntOn = try Date(learntOn, strategy: .iso8601)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.category = try container.decode(Category?.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.term, forKey: .term)
        try container.encode(self.learntOn, forKey: .learntOn)
        try container.encode(self.notes, forKey: .notes)
        try container.encode(self.category, forKey: .category)
    }
    
    static func decodeWords(from json: String) throws -> [Word] {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Word].self, from: data)
    }
    
    static func encodeWords(_ words: [Word]) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let encodedWords = try encoder.encode(words)
        return String(data: encodedWords, encoding: .utf8)!
    }
    
    /// The predicate used for querying the list of words.
    static func predicate(category: Category?) -> Predicate<Word> {
        let categoryName = category?.name
        
        return #Predicate<Word> { word in
            // the predicate does not support comparing two different objects (either Words or Categories);
            // also, Predicates do not support external variables, local ones have to be used:
            // the working solution is to compare strings and not objects and use a local variable (categoryName)
            categoryName == nil || word.category?.name == categoryName
        }
    }
    
    /// The sort order used for querying the list of words.
    static let sortDescriptors = [SortDescriptor(\Word.learntOn, order: .reverse)]
    
    static let example = Word(term: "Swift", learntOn: .now, notes: "A swift testing word.")
    static let otherExample = Word(term: "Apple", learntOn: .now.addingTimeInterval(-86400), notes: "A fruit or a company?")
}
