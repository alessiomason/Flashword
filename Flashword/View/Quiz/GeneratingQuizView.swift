//
//  GeneratingQuizView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/08/25.
//

import SwiftUI

struct GeneratingQuizView: View {
    let backgroundGradient: LinearGradient
    @State private var animatingSymbol = false
    
    var body: some View {
        VStack {
            Image(systemName: "questionmark.text.page")
                .font(.system(size: 150))
                .symbolEffect(.pulse, options: .repeat(.periodic), value: animatingSymbol)
                .onAppear {
                    animatingSymbol = true
                }
            
            Text("Generating the quiz…")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom)
            
            Image(systemName: "apple.intelligence")
                .font(.title2)
                .padding(.bottom, 4)
            Text("Powered by Apple Intelligence")
                .padding(.bottom, 16)
            
            Image(systemName: "lock")
                .font(.title2)
                .padding(.bottom, 4)
            Text("Your data are secure and never leave your device")
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient)
    }
}

#Preview {
    GeneratingQuizView(backgroundGradient: LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
