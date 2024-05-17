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
        TabView {
            VStack(alignment: .leading) {
                Text("Category: \(word.categoryName)", comment: "The category the word belongs to")
                    .padding(.bottom, 10)
                
                Spacer()
                
                Text("Word learnt on \(word.learntOn.formatted(date: .complete, time: .shortened))", comment: "The time the word has been learnt, including the name of the day, the date and the time")
            }
            .if(word.category != nil) { view in
                view.containerBackground(word.category!.tintColor.gradient, for: .tabView)
            }
            
            if !word.notes.isEmpty {
                VStack {
                    Text("Notes")
                        .padding(.bottom, 5)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(word.notes)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .if(word.category != nil) { view in
                    view.containerBackground(word.category!.tintColor.gradient, for: .tabView)
                }
            }
        }
        .tabViewStyle(.verticalPage)
        .navigationTitle(word.term)
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
