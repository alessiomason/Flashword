//
//  Quiz.swift
//  Flashword
//
//  Created by Alessio Mason on 18/08/25.
//

import Foundation
import FoundationModels

@Generable
struct Quiz {
    @Guide(description: "The question for the user. It MUST NOT include the provided word, which constitutes the answer.")
    var question: String
    
    @Guide(description: "The word that this question is about.")
    var word: String
    
    @Guide(description: "The uuidString of the word that this question is about.")
    var wordId: String
    
    @Guide(description: "List 4 possible answers to the previous question. One of the 4 answers MUST be the same as the word. ALL the answers MUST be different from one another.")
    var possibleAnswers: [String] = []
}
