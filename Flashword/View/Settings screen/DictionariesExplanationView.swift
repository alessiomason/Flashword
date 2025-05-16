//
//  DictionariesExplanationView.swift
//  Flashword
//
//  Created by Alessio Mason on 23/12/24.
//

import SwiftUI

struct DictionariesExplanationView: View {
    private let dictionaryExplanation = String(localized: """
Flashword uses the system dictionaries to provide definitions for your words.

To manage your dictionaries (or to download them for the first time, if you haven't already) you can go to Settings → General → Dictionary on your iPhone.
Alternatively, when looking up a word in Flashword, you can tap the \"Manage Dictionaries\" button to access the same settings.
""")
    
    var body: some View {
        List {
            Text(dictionaryExplanation)
                .padding(.horizontal, 5)
        }
        .navigationTitle("How to manage your dictionaries")
    }
}

#Preview {
    DictionariesExplanationView()
}
