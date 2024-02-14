//
//  ChooseSymbolView.swift
//  Flashword
//
//  Created by Alessio Mason on 14/02/24.
//

import SwiftUI

struct ChooseSymbolView: View {
    let columns = [GridItem(.adaptive(minimum: 40))]
    let selectedColorChoice: ColorChoice
    @Binding var selectedSymbol: Symbol
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Symbol.allCases, id: \.self) { symbol in
                Button {
                    selectedSymbol = symbol
                } label: {
                    Image(systemName: symbol.rawValue)
                        .font(.title)
                        .padding(10)
                        .foregroundStyle(selectedSymbol == symbol ? .white : .black)
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
    ChooseSymbolView(selectedColorChoice: ColorChoice.choices[0], selectedSymbol: .constant(Symbol.allCases[0]))
}
