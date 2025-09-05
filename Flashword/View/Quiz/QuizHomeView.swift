//
//  QuizHomeView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/08/25.
//

import SwiftUI

struct QuizHomeView: View {
    @State private var quizWords: [Word] = []
    @State private var quiz: [Quiz] = []
    @State private var numberOfWords = 5
    @State private var quizType: QuizType = .multipleChoice
    @State private var quizPhase: QuizPhase = .start
    
    let backgroundGradient: LinearGradient
    
    var body: some View {
        Group {
            switch quizPhase {
                case .start:
                    QuizSetupView(quizWords: $quizWords, numberOfWords: $numberOfWords, quizType: $quizType, quizPhase: $quizPhase, quiz: $quiz, backgroundGradient: backgroundGradient)
                case .generating:
                    GeneratingQuizView(backgroundGradient: backgroundGradient)
                case .quizzing:
                    QuizView(numberOfWords: numberOfWords, quizType: quizType, quizPhase: $quizPhase, quiz: $quiz, backgroundGradient: backgroundGradient)
                case .complete:
                    QuizCompleteView(quizWords: $quizWords, quizPhase: $quizPhase, quiz: $quiz, backgroundGradient: backgroundGradient)
            }
        }
    }
}

#Preview {
    QuizHomeView(backgroundGradient: LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
}
