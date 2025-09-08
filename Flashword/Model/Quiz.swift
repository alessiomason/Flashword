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
    @Guide(description: String(localized: "The question for the user. It MUST NOT include the provided word, which constitutes the answer."))
    var question: String
    
    @Guide(description: String(localized: "The word that this question is about."))
    var word: String
    
    @Guide(description: String(localized: "Ignore this field."))
    var wordId: String = ""
    
    @Guide(description: String(localized: "List 4 possible answers to the previous question. One of the 4 answers MUST be the same as the word. ALL the answers MUST be different from one another and MUST be in the same language of the provided word."))
    var possibleAnswers: [String] = []
    
    @Guide(description: String(localized: "Ignore this field."))
    var answeredCorrectly: Bool = false
}

enum QuizType {
    case multipleChoice, openAnswer
}

enum QuizPhase {
    case start, generating, quizzing, complete
}
