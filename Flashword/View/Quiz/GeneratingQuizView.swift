//
//  GeneratingQuizView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/08/25.
//

import SwiftUI

struct GeneratingQuizView: View {
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.extraLarge)
            
            Text("Generating the quiz…")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Powered by Apple Intelligence")
            
            Text("Your data are secure and will never be shared.")
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    GeneratingQuizView()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
