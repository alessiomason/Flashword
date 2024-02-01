//
//  Word.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI
import SwiftData

@Model
class Word {
    let term: String
    let learntOn: Date
    var notes: String
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
    
    #if DEBUG
    static let example = Word(term: "Swift", learntOn: .now, notes: "A swift testing word.")
    static let otherExample = Word(term: "Apple", learntOn: .now.addingTimeInterval(-86400), notes: "A fruit or a company?")
    #endif
}
