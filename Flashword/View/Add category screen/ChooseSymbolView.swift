//
//  ChooseSymbolView.swift
//  Flashword
//
//  Created by Alessio Mason on 14/02/24.
//

import SwiftUI

struct ChooseSymbolView: View {
    let selectedColorChoice: ColorChoice
    @Binding var previouslySelectedSymbol: Symbol
    @Binding var selectedSymbol: Symbol
    
    var body: some View {
        List {
            Section("Weather") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.weather, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
            
            Section("Maps and transports") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.transports, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
            
            Section("Objects") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.objects, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
            
            Section("Devices") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.devices, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
            
            Section("People") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.people, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
            
            Section("Sports") {
                ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: Symbol.sports, previouslySelectedSymbol: $previouslySelectedSymbol, selectedSymbol: $selectedSymbol)
            }
        }
        .navigationTitle("Choose a symbol for the category")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.impact, trigger: selectedSymbol)
    }
}

struct ChooseHighlightedSymbolView: View {
    let selectedColorChoice: ColorChoice
    let previouslySelectedSymbol: Symbol
    @Binding var selectedSymbol: Symbol
    
    // This ensures the list of symbols contains the one previously selected and that the list does not change
    // even if a new selection is made.  It only changes when a selection is made from ChooseSymbolView.
    var symbols: [Symbol] {
        if Symbol.suggested.contains(previouslySelectedSymbol) {
            return Symbol.suggested
        } else {
            var expandedList = Symbol.suggested
            expandedList.insert(previouslySelectedSymbol, at: 0)
            expandedList.removeLast()   // to ensure the list still contains only 16 elements
            return expandedList
        }
    }
    
    var body: some View {
        // Constant binding as, in this case, the previously selected symbol must not change, to ensure
        // that it is still displayed even if the current selection changes.
        ChooseSymbolGridView(selectedColorChoice: selectedColorChoice, symbols: symbols, previouslySelectedSymbol: .constant(previouslySelectedSymbol), selectedSymbol: $selectedSymbol)
            .sensoryFeedback(.impact, trigger: selectedSymbol)
    }
}

private struct ChooseSymbolGridView: View {
    let columns = [GridItem(.adaptive(minimum: 40))]
    let selectedColorChoice: ColorChoice
    let symbols: [Symbol]
    @Binding var previouslySelectedSymbol: Symbol
    @Binding var selectedSymbol: Symbol
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(symbols, id: \.self) { symbol in
                Button {
                    previouslySelectedSymbol = symbol
                    selectedSymbol = symbol
                } label: {
                    Image(systemName: symbol.rawValue)
                        .font(.title)
                        .padding(10)
                        .foregroundStyle(selectedSymbol == symbol ? .white : .primary)
                        .background {
                            if selectedSymbol == symbol {
                                Circle()
                                    .foregroundStyle(
                                        LinearGradient(colors: [selectedColorChoice.primaryColor, selectedColorChoice.secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                            }
                        }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ChooseSymbolView(selectedColorChoice: ColorChoice.choices[0]!, previouslySelectedSymbol: .constant(Symbol.allCases[0]), selectedSymbol: .constant(Symbol.allCases[0]))
}

#Preview("ChooseHighlightedSymbolView") {
    ChooseHighlightedSymbolView(selectedColorChoice: ColorChoice.choices[0]!, previouslySelectedSymbol: Symbol.allCases[0], selectedSymbol: .constant(Symbol.allCases[0]))
    
}
