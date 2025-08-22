//
//  QuizCompleteView.swift
//  Flashword
//
//  Created by Alessio Mason on 22/08/25.
//

import SwiftUI

struct QuizCompleteView: View {
    @Binding var quizWords: [Word]
    @Binding var quizPhase: QuizPhase
    @Binding var quiz: [Quiz]
    
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
                
                ForEach(quizWords) { word in
                    HStack {
                        Text(word.term)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button("See word") {
                            
                        }
                        .buttonStyle(.bordered)
                        
                        ShowDictionaryButton(term: word.term, primaryColor: .white, secondaryColor: .blue, smaller: true)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .safeAreaBar(
            edge: .bottom,
            alignment: .center,
            spacing: 0) {
                Button {
                    withAnimation {
                        quizPhase = .start
                        quizWords = []
                        quiz = []
                    }
                } label: {
                    Text("Close quiz")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .tint(.mint)
                .buttonStyle(.glassProminent)
                .padding(16)
            }
    }
}

#Preview {
    QuizCompleteView(quizWords: .constant([Word.example, Word.otherExample]), quizPhase: .constant(.complete), quiz: .constant([]))
}
