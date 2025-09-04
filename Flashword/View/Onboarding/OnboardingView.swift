//
//  OnboardingView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

enum OnboardingTabs {
    case welcome, newVersion
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var onboardingTab = OnboardingTabs.welcome
    
    var body: some View {
        VStack {
            Image(.flashwordIcon)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.4
                }
                .padding(8)
            
            Text("Welcome to")
                .font(.title)
                .fontWeight(.medium)
            
            Text("Flashword")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.linearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Picker("Onboarding tab", selection: $onboardingTab) {
                Text("Flashword").tag(OnboardingTabs.welcome)
                Text("Novità dell'aggiornamento").tag(OnboardingTabs.newVersion)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ScrollView {
                switch onboardingTab {
                    case .welcome:
                        AppPresentationView()
                    case .newVersion:
                        Text("Versione 4.0")
                }
            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity)
        .animation(.default, value: onboardingTab)
        .safeAreaBar(
            edge: .bottom,
            alignment: .center,
            spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Text("Begin")
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
    OnboardingView()
}
