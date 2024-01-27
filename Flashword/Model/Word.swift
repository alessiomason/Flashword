//
//  Word.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import Foundation
import SwiftData

@Model
class Word: Comparable {
    let term: String
    let learntOn: Date
    var notes: String
    @Relationship(inverse: \Category.words) var category: Category?
    
    var categoryName: String {
        let localizedNoCategory = String(localized: "No category", comment: "The text to display in absence of a user-defined category")
        return category?.name ?? localizedNoCategory
    }
    
    init(term: String, learntOn: Date, notes: String = "", category: Category? = nil) {
        self.term = term
        self.learntOn = learntOn
        self.notes = notes
        self.category = category
    }
    
    static func <(lhs: Word, rhs: Word) -> Bool {
        lhs.learntOn > rhs.learntOn
    }
    
    #if DEBUG
    static let example = Word(term: "Swift", learntOn: .now, notes: "A swift testing word.")
    static let otherExample = Word(term: "Apple", learntOn: .now.addingTimeInterval(-86400), notes: "A fruit or a company?")
    #endif
}
