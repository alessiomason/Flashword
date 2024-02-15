//
//  Category.swift
//  Flashword
//
//  Created by Alessio Mason on 25/01/24.
//
//  Category only contains the id of the chosen color. This was done to avoid saving the whole ColorChoice struct in SwiftData,
//  avoiding to code the Color properties contained (which would have to be decomposed to their components).

import SwiftUI
import SwiftData

@Model
class Category: Codable, Equatable {
    enum CodingKeys: CodingKey {
        case name, primaryColor, secondaryColor, colorChoiceId, symbol
    }
    
    @Attribute(.unique) var name: String
    var colorChoiceId: Int
    var symbol: Symbol
    var words = [Word]()
    
    var primaryColor: Color {
        ColorChoice.choices[colorChoiceId]?.primaryColor ?? .mint
    }
    var secondaryColor: Color {
        ColorChoice.choices[colorChoiceId]?.secondaryColor ?? .blue
    }
    
    init(name: String, colorChoiceId: Int, symbol: Symbol) {
        self.name = name
        self.colorChoiceId = colorChoiceId
        self.symbol = symbol
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.colorChoiceId = try container.decode(Int.self, forKey: .colorChoiceId)
        self.symbol = try container.decode(Symbol.self, forKey: .symbol)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.colorChoiceId, forKey: .colorChoiceId)
        try container.encode(self.symbol, forKey: .symbol)
    }
    
    static func decodeCategories(from json: String) throws -> [Category] {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Category].self, from: data)
    }
    
    static func encodeCategories(_ categories: [Category]) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let encodedCategories = try encoder.encode(categories)
        return String(data: encodedCategories, encoding: .utf8)!
    }
    
    static func ==(lhs: Category, rhs: Category) -> Bool {
        lhs.name == rhs.name
    }
    
    /// The sort order used for querying the list of categories.
    static let sortDescriptors = [SortDescriptor(\Category.name)]
    
    static let example = Category(name: "General", colorChoiceId: 0, symbol: .bolt)
    static let otherExample = Category(name: "Italian words", colorChoiceId: 1, symbol: .car)
}
