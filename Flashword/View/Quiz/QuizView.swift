//
//  QuizView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/08/25.
//

import SwiftUI

struct QuizView: View {
    enum QuestionPhase {
        case question, feedback
    }
    
    let wordsNumber: Int
    let quizType: QuizType
    @Binding var quizPhase: QuizPhase
    let quiz: [Quiz]
    @State private var currentQuestion = 0
    @State private var questionPhase: QuestionPhase = .question
    @State private var userAnswer = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Question \(currentQuestion + 1)/\(quiz.count)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                switch questionPhase {
                    case .question:
                        Text(quiz[currentQuestion].question)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        ForEach(quiz[currentQuestion].possibleAnswers, id: \.self) { possibleAnswer in
                            Text(possibleAnswer)
                        }
                        
                        TextField("Your answer", text: $userAnswer)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    case .feedback:
                        Text("Correct answer: \(quiz[currentQuestion].word)")
                }
                
                Button {
                    switch questionPhase {
                        case .question:
                            withAnimation {
                                questionPhase = .feedback
                            }
                        case .feedback:
                            withAnimation {
                                if currentQuestion + 1 < wordsNumber {
                                    currentQuestion += 1
                                    questionPhase = .question
                                } else {
                                    quizPhase = .complete
                                }
                            }
                    }
                } label: {
                    Text(questionPhase == .question ? "Confirm" : "Continue")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .buttonStyle(.glassProminent)
                .padding(16)
                .disabled(questionPhase == .feedback && currentQuestion + 1 >= quiz.count)
                
                if questionPhase == .feedback && currentQuestion + 1 >= quiz.count {
                    Text("Still generating the following question. Hang on tight!")
                        .padding(.horizontal, 24)
                }
            }
            .foregroundStyle(.white)
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    let quiz = [
        Quiz(question: "What word can describe the sun?", word: "Bright", wordId: "1"),
        Quiz(question: "What is the capital of Italy?", word: "Rome", wordId: "2")
    ]
    
    QuizView(wordsNumber: 5, quizType: .openAnswer, quizPhase: .constant(.quizzing), quiz: quiz)
}
