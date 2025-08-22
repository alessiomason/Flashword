//
//  QuizButtonView.swift
//  Flashword
//
//  Created by Alessio Mason on 21/08/25.
//

import SwiftUI

struct QuizButtonView: View {
    let text: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background(selected ? .blue : .mint)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selected ? .mint : .blue, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    QuizButtonView(text: "Click me", selected: false, action: {})
}
