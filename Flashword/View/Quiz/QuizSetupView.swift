//
//  QuizSetupView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/08/25.
//

import FoundationModels
import GameplayKit
import SwiftData
import SwiftUI

struct QuizSetupView: View {
    @Environment(\.modelContext) private var modelContext
    
    // a session that spans across multiple requests is not needed, so I could refresh the session at every request
    // and not keep it in a state, but it is probably faster to instantiate a new session only when needed
    @State private var session = LanguageModelSession()
    
    @Query private var words: [Word]
    @Binding var quizWords: [Word]
    @Binding var numberOfWords: Int
    @Binding var quizType: QuizType
    @Binding var quizPhase: QuizPhase
    @Binding var quiz: [Quiz]
    
    private var numberOfSavedWords: Int {
        let descriptor = FetchDescriptor<Word>()
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "questionmark.text.page")
                    .font(.system(size: 150))
                    .padding(.vertical)
                
                Text("Quiz")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Test your knowledge of the words you saved!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                Text("Number of questions")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Picker("Number of questions", selection: $numberOfWords) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    if numberOfSavedWords > 25 {
                        Text("25").tag(25)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                Text("Quiz type")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Picker("Quiz type", selection: $quizType) {
                    Text("Multiple choice").tag(QuizType.multipleChoice)
                    Text("Open answer").tag(QuizType.openAnswer)
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaBar(
            edge: .bottom,
            alignment: .center,
            spacing: 0) {
                Button {
                    Task {
                        try await generate()
                    }
                } label: {
                    Text("Generate quiz")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .tint(.mint)
                .buttonStyle(.glassProminent)
                .padding(16)
            }
    }
    
    private func generate() async throws {
        withAnimation {
            quizPhase = .generating
        }
        
        let shuffled = GKShuffledDistribution(lowestValue: 0, highestValue: words.count - 1)
        
        for _ in 0..<numberOfWords {
            var randomIndex = shuffled.nextInt()
            var word = words[randomIndex]
            
            var responseContent: Quiz? = nil
            while responseContent == nil {
                let prompt = String(localized: """
                Your goal is to generate a multiple-choice quiz. Generate a question that quizzes the user knowledge of the word "\(word.term)". The goal is for the user to correctly guess the word that you are referring to in the question. The question MUST NOT include the word "\(word.term)".
        
                Example of question
                Word: Attainable
                Question: "What is a word that expresses that something is possible to do?"
                Possible answers: [Difficult, Attainable, Impossible, Preposterous]
        
                The word ("Attainable", in this case) MUST be included amongst the 4 possible answers and MUST NEVER be mentioned in the question. The other possible answers MUST be plausible but wrong and MUST all be different from one another. All the possible answers MUST be in the same language of the provided word.
        
        
                Example of a WRONG question --> DO NOT GENERATE QUESTIONS LIKE THIS ONE!
                Question: "What does 'Attainable' mean?"
                This question is not suitable for the game because it contains the word itself ("Attainable", in this case) in the question.
        
        
                Generate a question for the word "\(word.term)".
        """)
                
                do {
                    let response = try await session.respond(
                        to: prompt,
                        generating: Quiz.self
                    )
                    
                    responseContent = response.content
                    if response.content.possibleAnswers.count < 4 {
                        responseContent = nil
                    }
                } catch LanguageModelSession.GenerationError.guardrailViolation {
                    // safety guardrail triggered, change word
                    randomIndex = shuffled.nextInt()
                    word = words[randomIndex]
                    responseContent = nil
                } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
                    session = LanguageModelSession()
                } catch {
                    print("Unexpected error: \(error)")
                }
            }
            
            responseContent!.word = word.term
            responseContent!.wordId = word.uuid.uuidString
            responseContent!.answeredCorrectly = false
            if !responseContent!.possibleAnswers.map({ $0.lowercased() }).contains(word.term.lowercased()) {
                responseContent!.possibleAnswers[0] = word.term     // add correct answer if missing
            }
            
            quiz.append(responseContent!)
            quizWords.append(word)
            
            if quizPhase != .quizzing {
                withAnimation {     // start quizzing as soon as you have one question
                    quizPhase = .quizzing
                }
            }
        }
    }
}

#Preview {
    QuizSetupView(
        quizWords: .constant([]),
        numberOfWords: .constant(5),
        quizType: .constant(.multipleChoice),
        quizPhase: .constant(.start),
        quiz: .constant([])
    )
    .background(.mint)
}
