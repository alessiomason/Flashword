//
//  QuizView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/08/25.
//

import SwiftData
import SwiftUI

struct QuizView: View {
    enum QuestionPhase {
        case question, feedback
    }
    
    let numberOfWords: Int
    let quizType: QuizType
    @Binding var quizPhase: QuizPhase
    @Binding var quiz: [Quiz]
    @State private var currentQuestion = 0
    @State private var questionPhase: QuestionPhase = .question
    @State private var userAnswer = ""
    @FocusState private var focusingTextField: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var wordToBeShown: Word? = nil
    
    let backgroundGradient: LinearGradient
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Question \(currentQuestion + 1)/\(numberOfWords)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                switch questionPhase {
                    case .question:
                        Text(quiz[currentQuestion].question)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        switch quizType {
                            case .multipleChoice:
                                VStack {
                                    HStack {
                                        QuizButtonView(
                                            text: quiz[currentQuestion].possibleAnswers[0],
                                            selected: userAnswer == quiz[currentQuestion].possibleAnswers[0]
                                        ) {
                                            withAnimation {
                                                userAnswer = quiz[currentQuestion].possibleAnswers[0]
                                            }
                                        }
                                        
                                        QuizButtonView(
                                            text: quiz[currentQuestion].possibleAnswers[1],
                                            selected: userAnswer == quiz[currentQuestion].possibleAnswers[1]
                                        ) {
                                            withAnimation {
                                                userAnswer = quiz[currentQuestion].possibleAnswers[1]
                                            }
                                        }
                                    }
                                    
                                    HStack {
                                        QuizButtonView(
                                            text: quiz[currentQuestion].possibleAnswers[2],
                                            selected: userAnswer == quiz[currentQuestion].possibleAnswers[2]
                                        ) {
                                            withAnimation {
                                                userAnswer = quiz[currentQuestion].possibleAnswers[2]
                                            }
                                        }
                                        
                                        QuizButtonView(
                                            text: quiz[currentQuestion].possibleAnswers[3],
                                            selected: userAnswer == quiz[currentQuestion].possibleAnswers[3]
                                        ) {
                                            withAnimation {
                                                userAnswer = quiz[currentQuestion].possibleAnswers[3]
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                                
                            case .openAnswer:
                                TextField("Your answer", text: $userAnswer)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusingTextField)
                                    .padding()
                        }
                    case .feedback:
                        VStack {
                            if userAnswer.trimmingCharacters(in: .whitespaces).lowercased() == quiz[currentQuestion].word.lowercased() {
                                Text("Correct!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            } else {
                                Text("Almost!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Text("The answer was: \(quiz[currentQuestion].word)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical)
                            
                            Button("Show word's page", action: showWordPage)
                                .buttonStyle(.bordered)
                            
                            ShowDictionaryButton(term: quiz[currentQuestion].word, primaryColor: .blue, secondaryColor: .white, onWhiteBackground: false)
                        }
                        .frame(maxWidth: .infinity)
                }
            }
            .foregroundStyle(.white)
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(backgroundGradient)
        .safeAreaBar(
            edge: .bottom,
            alignment: .center,
            spacing: 0) {
                VStack {
                    if questionPhase == .feedback && currentQuestion + 1 < numberOfWords && currentQuestion + 1 >= quiz.count {
                        Text("Still generating the following question. Hang on tight!")
                            .padding(.horizontal, 64)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        switch questionPhase {
                            case .question:
                                withAnimation {
                                    focusingTextField = false
                                    quiz[currentQuestion].answeredCorrectly = userAnswer.trimmingCharacters(in: .whitespaces).lowercased() == quiz[currentQuestion].word.lowercased()
                                    questionPhase = .feedback
                                }
                            case .feedback:
                                withAnimation {
                                    if currentQuestion + 1 < numberOfWords {
                                        currentQuestion += 1
                                        userAnswer = ""
                                        questionPhase = .question
                                    } else {
                                        quizPhase = .complete
                                    }
                                }
                        }
                    } label: {
                        Text(questionPhase == .question ? "Confirm" : "Continue")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                    .tint(.mint)
                    .buttonStyle(.glassProminent)
                    .padding(16)
                    .disabled(userAnswer == "" || questionPhase == .feedback && currentQuestion + 1 < numberOfWords && currentQuestion + 1 >= quiz.count)
                }
            }
            .sheet(item: $wordToBeShown) { word in
                NavigationStack {
                    WordView(word: word)
                        .navigationTitle(word.term)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(role: .close) {
                                    wordToBeShown = nil
                                }
                            }
                        }
                }
            }
    }
    
    private func showWordPage() {
        guard let wordId = UUID(uuidString: quiz[currentQuestion].wordId) else { return }
        let descriptor = FetchDescriptor<Word>(
            predicate: #Predicate<Word> { word in
                word.uuid == wordId
            }
        )
        
        guard let word = try? modelContext.fetch(descriptor).first else { return }
        wordToBeShown = word
    }
}

#Preview {
    let quiz = [
        Quiz(question: "What word can describe the sun?", word: "Bright", wordId: "1", possibleAnswers: [
            "Bright",
            "Green",
            "Cold",
            "Cool"
        ]),
        Quiz(question: "What is the capital of Italy?", word: "Rome", wordId: "2")
    ]
    
    QuizView(numberOfWords: 5, quizType: .multipleChoice, quizPhase: .constant(.quizzing), quiz: .constant(quiz), backgroundGradient: LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
}

