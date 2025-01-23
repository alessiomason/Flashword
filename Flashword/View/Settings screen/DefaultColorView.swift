//
//  DefaultColorView.swift
//  Flashword
//
//  Created by Alessio Mason on 23/12/24.
//

import SwiftUI

struct DefaultColorView: View {
    @AppStorage("defaultColorChoiceId") private var defaultColorChoiceId = 0
    private var defaultColorChoice: ColorChoice {
        ColorChoice.choices[defaultColorChoiceId] ?? ColorChoice.choices[0]!
    }
    
    var body: some View {
        List {
            Section {
                ChooseColorView(selectedColorChoiceId: $defaultColorChoiceId)
            } header: {
                Text("Pick a color")
            } footer: {
                Text("Choose the color for the words that do not belong to a specific category.")
            }
        }
        .navigationTitle("Uncategorized words color")
    }
}

#Preview {
    DefaultColorView()
}
