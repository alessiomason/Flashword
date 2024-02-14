//
//  Category.swift
//  Flashword
//
//  Created by Alessio Mason on 25/01/24.
//

import SwiftUI
import SwiftData

@Model
class Category: Codable, Equatable {
    enum CodingKeys: CodingKey {
        case name, primaryColor, secondaryColor, colorChoiceId, symbol
    }
    
    @Attribute(.unique) var name: String
    var primaryColorComponents: ColorComponents
    var secondaryColorComponents: ColorComponents
    var colorChoiceId: UUID? = nil
    var symbol: Symbol? = nil
    var words = [Word]()
    
    var primaryColor: Color {
        Color(colorComponents: primaryColorComponents)
    }
    var secondaryColor: Color {
        Color(colorComponents: secondaryColorComponents)
    }
    
    init(name: String, primaryColorComponents: ColorComponents, secondaryColorComponents: ColorComponents, colorChoiceId: UUID? = nil, symbol: Symbol? = nil) {
        self.name = name
        self.primaryColorComponents = primaryColorComponents
        self.secondaryColorComponents = secondaryColorComponents
        self.colorChoiceId = colorChoiceId
        self.symbol = symbol
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryColorComponents = try container.decode(ColorComponents.self, forKey: .primaryColor)
        self.secondaryColorComponents = try container.decode(ColorComponents.self, forKey: .secondaryColor)
        self.colorChoiceId = try container.decode(UUID.self, forKey: .colorChoiceId)
        self.symbol = try container.decode(Symbol.self, forKey: .symbol)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.primaryColorComponents, forKey: .primaryColor)
        try container.encode(self.secondaryColorComponents, forKey: .secondaryColor)
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
    
    static let example = Category(name: "General", primaryColorComponents: ColorComponents(color: .mint), secondaryColorComponents: ColorComponents(color: .blue), colorChoiceId: ColorChoice.choices[0].id, symbol: .bolt)
    static let otherExample = Category(name: "Italian words", primaryColorComponents: ColorComponents(color: .yellow), secondaryColorComponents: ColorComponents(color: .red), colorChoiceId: ColorChoice.choices[1].id, symbol: .car)
}
