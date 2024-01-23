//
//  Word.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import Foundation
import SwiftData

@Model
class Word {
    let term: String
    let learntOn: Date
    var notes: String
    
    init(term: String, learntOn: Date, notes: String = "") {
        self.term = term
        self.learntOn = learntOn
        self.notes = notes
    }
    
#if DEBUG
    static let example = Word(term: "Swift", learntOn: .now, notes: "A swift testing word.")
#endif
}
