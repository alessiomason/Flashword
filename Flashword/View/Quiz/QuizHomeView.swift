//
//  QuizHomeView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/08/25.
//

import SwiftUI

enum QuizType {
    case multipleChoice, openAnswer
}

enum QuizPhase {
    case start, generating, quizzing, complete
}

struct QuizHomeView: View {
    @State private var quizWords: [Word] = []
    @State private var quiz: [Quiz] = []
    @State private var wordsNumber = 5
    @State private var quizType: QuizType = .multipleChoice
    @State private var quizPhase: QuizPhase = .start
    
    var body: some View {
        Group {
            switch quizPhase {
                case .start:
                    QuizSetupView(quizWords: $quizWords, wordsNumber: $wordsNumber, quizType: $quizType, quizPhase: $quizPhase, quiz: $quiz)
                case .generating:
                    GeneratingQuizView()
                case .quizzing:
                    QuizView(wordsNumber: wordsNumber, quizType: quizType, quizPhase: $quizPhase, quiz: quiz)
                case .complete:
                    Text("Complete")
            }
        }
    }
}

#Preview {
    QuizHomeView()
}
