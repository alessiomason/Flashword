//
//  QuizCompleteView.swift
//  Flashword
//
//  Created by Alessio Mason on 22/08/25.
//

import SwiftData
import SwiftUI

struct QuizCompleteView: View {
    @Binding var quizWords: [Word]
    @Binding var quizPhase: QuizPhase
    @Binding var quiz: [Quiz]
    
    @Environment(\.modelContext) private var modelContext
    @State private var wordToBeShown: Word? = nil
    
    let backgroundGradient: LinearGradient
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Finished!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Review the quiz words")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                
                ForEach(quizWords.enumerated(), id: \.element.uuid) { index, word in
                    HStack {
                        if quiz[index].answeredCorrectly {
                            Image(systemName: "checkmark.circle")
                        } else {
                            Image(systemName: "x.circle")
                        }
                        
                        
                        Text(word.term)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button("See word's page") {
                            showWordPage(wordUuid: word.uuid)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                }
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(backgroundGradient)
        .safeAreaBar(
            edge: .bottom,
            alignment: .center,
            spacing: 0) {
                Button {
                    withAnimation {
                        quizPhase = .start
                    }
                } label: {
                    Text("Close quiz")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .tint(.mint)
                .buttonStyle(.glassProminent)
                .padding(16)
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
            .onDisappear {
                quizWords = []
                quiz = []
            }
    }
    
    private func showWordPage(wordUuid: UUID) {
        let wordId = wordUuid       // SwiftData only works with local variables
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
    let quiz = [Quiz(question: "", word: "", answeredCorrectly: true), Quiz(question: "", word: "", answeredCorrectly: false)]
    
    QuizCompleteView(quizWords: .constant([Word.example, Word.otherExample]), quizPhase: .constant(.complete), quiz: .constant(quiz), backgroundGradient: LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
}
