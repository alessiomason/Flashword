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
    
    @ViewBuilder
    private var background: some View {
        if selected {
            ZStack {
                LinearGradient(stops: [Gradient.Stop(color: .blue, location: -0.25), Gradient.Stop(color: .mint, location: 0.1), Gradient.Stop(color: .mint, location: 0.9), Gradient.Stop(color: .blue, location: 1.25)], startPoint: .top, endPoint: .bottom)
                
                LinearGradient(stops: [Gradient.Stop(color: .blue, location: -0.25), Gradient.Stop(color: .mint.opacity(0), location: 0.07), Gradient.Stop(color: .mint.opacity(0), location: 0.93), Gradient.Stop(color: .blue, location: 1.25)], startPoint: .leading, endPoint: .trailing)
            }
        } else {
            LinearGradient(stops: [Gradient.Stop(color: .mint, location: -0.25), Gradient.Stop(color: .blue, location: 0.5), Gradient.Stop(color: .mint, location: 1.25)], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(selected ? .blue : .mint, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    QuizButtonView(text: "Click me", selected: false, action: {})
}
