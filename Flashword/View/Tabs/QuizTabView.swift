//
//  QuizTabView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/08/25.
//

import FoundationModels
import SwiftUI

struct QuizTabView: View {
    @Environment(\.colorScheme) var colorScheme
    private let model = SystemLanguageModel.default
    
    private var errorText: String {
        return switch model.availability {
            case .available:
                ""
            case.unavailable(.deviceNotEligible):
                String(localized: "Sorry, the quiz functionality is not available! Quizzes are generated using Apple Intelligence, which is not supported by your device.")
            case .unavailable(.appleIntelligenceNotEnabled):
                String(localized: "Quizzes are generated using Apple Intelligence. If you wish to use this functionality, turn on Apple Intelligence in your device settings.")
            case .unavailable(.modelNotReady):
                // The model isn't ready because it's downloading or because of other system reasons.
                String(localized: "Quizzes are generated using Apple Intelligence, which is currently not available on your device (it is likely still downloading). Please try again later.")
            case .unavailable:
                // The model is unavailable for an unknown reason.
                String(localized: "Sorry, the quiz functionality is not available! Quizzes are generated using Apple Intelligence, which is currently not available on your device.")
        }
    }
    
    private var backgroundGradient: LinearGradient {
        return if colorScheme == .dark {
            LinearGradient(
                stops: [Gradient.Stop(color: .mint, location: -0.25),
                        Gradient.Stop(color: .black, location: 1.3)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                switch model.availability {
                    case .available:
                        QuizHomeView()
                    default:
                        QuizUnavailableView(errorText: errorText)
                }
            }
        }
    }
}

#Preview {
    QuizTabView()
}
