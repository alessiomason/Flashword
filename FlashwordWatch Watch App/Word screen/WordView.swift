//
//  WordView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

struct WordView: View {
    let word: Word
    
    var body: some View {
        Text(word.term)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return NavigationStack {
            WordView(word: .example)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
