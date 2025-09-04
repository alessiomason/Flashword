//
//  QuizUnavailableView.swift
//  Flashword
//
//  Created by Alessio Mason on 25/08/25.
//

import SwiftUI

struct QuizUnavailableView: View {
    let errorText: String
    let backgroundGradient: LinearGradient
    
    var body: some View {
        VStack {
            Image(systemName: "questionmark.text.page")
                .font(.system(size: 150))
                .padding(.vertical)
            
            Text("Quiz")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.vertical)
            
            Text(errorText)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollBounceBehavior(.basedOnSize)
        .background(backgroundGradient)
    }
}

#Preview {
    QuizUnavailableView(errorText: "The quiz functionality is not supported.", backgroundGradient: LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
}
