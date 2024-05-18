//
//  WordCardView.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 16/05/24.
//

import SwiftData
import SwiftUI

struct WordCardView: View {
    @Environment(Router.self) private var router
    let word: Word
    
    var body: some View {
        NavigationLink(value: RouterDestination.word(word: word)) {
            HStack {
                CategoryIcon(category: word.category)
                    .padding(.vertical, 8)
                    .padding(.trailing, 8)
                    .fixedSize(horizontal: true, vertical: false)
                
                VStack(alignment: .leading) {
                    Text(word.term)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(word.learntOn.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        
        return List {
            WordCardView(word: .example)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
