//
//  Category.swift
//  Flashword
//
//  Created by Alessio Mason on 25/01/24.
//

import Foundation
import SwiftData

@Model
class Category: Codable, Equatable {
    enum CodingKeys: CodingKey {
        case name, primaryColor, secondaryColor
    }
    
    @Attribute(.unique) let name: String
    let primaryColor: ColorComponents
    let secondaryColor: ColorComponents
    var words = [Word]()
    
    init(name: String, primaryColor: ColorComponents, secondaryColor: ColorComponents) {
        self.name = name
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryColor = try container.decode(ColorComponents.self, forKey: .primaryColor)
        self.secondaryColor = try container.decode(ColorComponents.self, forKey: .secondaryColor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.primaryColor, forKey: .primaryColor)
        try container.encode(self.secondaryColor, forKey: .secondaryColor)
    }
    
    static func ==(lhs: Category, rhs: Category) -> Bool {
        lhs.name == rhs.name
    }
    
    //#if DEBUG
    static let example = Category(name: "General", primaryColor: ColorComponents(color: .mint), secondaryColor: ColorComponents(color: .blue))
    //#endif
}
