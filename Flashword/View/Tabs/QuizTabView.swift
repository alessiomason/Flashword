//
//  QuizTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/08/25.
//

import FoundationModels
import SwiftUI

struct QuizTabView: View {
    private var model = SystemLanguageModel.default
    
    var body: some View {
        NavigationStack {
            Group {
                switch model.availability {
                    case .available:
                        // Show your intelligence UI.
                        QuizHomeView()
                    case .unavailable(.deviceNotEligible):
                        // Show an alternative UI.
                        Text("Quizzes are generated using Apple Intelligence, which is not supported by your device.")
                    case .unavailable(.appleIntelligenceNotEnabled):
                        // Ask the person to turn on Apple Intelligence.
                        Text("Quizzes are generated using Apple Intelligence. If you wish to use this functionality, turn on Apple Intelligence in your device settings.")
                    case .unavailable(.modelNotReady):
                        // The model isn't ready because it's downloading or because of other system reasons.
                        Text("Quizzes are generated using Apple Intelligence, which is currently not available on your device. Please try again later.")
                    case .unavailable(let other):
                        // The model is unavailable for an unknown reason.
                        Text("Quizzes are generated using Apple Intelligence, which is currently not available on your device.")
                }
            }
        }
    }
}

#Preview {
    QuizTabView()
}
