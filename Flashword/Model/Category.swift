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
        case name, primaryColor, secondaryColor
    }
    
    @Attribute(.unique) var name: String
    var primaryColorComponents: ColorComponents
    var secondaryColorComponents: ColorComponents
    var colorChoiceId: UUID? = nil
    var words = [Word]()
    
    var primaryColor: Color {
        Color(colorComponents: primaryColorComponents)
    }
    var secondaryColor: Color {
        Color(colorComponents: secondaryColorComponents)
    }
    
    init(name: String, primaryColorComponents: ColorComponents, secondaryColorComponents: ColorComponents, colorChoiceId: UUID? = nil) {
        self.name = name
        self.primaryColorComponents = primaryColorComponents
        self.secondaryColorComponents = secondaryColorComponents
        self.colorChoiceId = colorChoiceId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryColorComponents = try container.decode(ColorComponents.self, forKey: .primaryColor)
        self.secondaryColorComponents = try container.decode(ColorComponents.self, forKey: .secondaryColor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.primaryColorComponents, forKey: .primaryColor)
        try container.encode(self.secondaryColorComponents, forKey: .secondaryColor)
    }
    
    static func ==(lhs: Category, rhs: Category) -> Bool {
        lhs.name == rhs.name
    }
    
    /// The sort order used for querying the list of categories.
    static let sortDescriptors = [SortDescriptor(\Category.name)]
    
    static let example = Category(name: "General", primaryColorComponents: ColorComponents(color: .mint), secondaryColorComponents: ColorComponents(color: .blue))
    static let otherExample = Category(name: "Italian words", primaryColorComponents: ColorComponents(color: .yellow), secondaryColorComponents: ColorComponents(color: .red), colorChoiceId: ColorChoice.choices[1].id)
}
