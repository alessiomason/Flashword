//
//  ChooseColorView.swift
//  Flashword
//
//  Created by Alessio Mason on 14/02/24.
//

import SwiftUI

struct ChooseColorView: View {
    let columns = [GridItem(.adaptive(minimum: 60))]
    @Binding var selectedColorChoice: ColorChoice
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(ColorChoice.choices.values) { colorChoice in
                Button {
                    selectedColorChoice = colorChoice
                } label: {
                    ZStack {
                        ColorCircle(primaryColor: colorChoice.primaryColor, secondaryColor: colorChoice.secondaryColor)
                            .frame(width: 60)
                        
                        if colorChoice == selectedColorChoice {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact, trigger: selectedColorChoice)
    }
}

#Preview {
    ChooseColorView(selectedColorChoice: .constant(ColorChoice.choices[0]!))
}
