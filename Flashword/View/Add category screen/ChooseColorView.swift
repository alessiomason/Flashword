//
//  ChooseColorView.swift
//  Flashword
//
//  Created by Alessio Mason on 14/02/24.
//

import SwiftUI

struct ChooseColorView: View {
    let columns = [GridItem(.adaptive(minimum: 60))]
    @Binding var selectedColorChoiceId: Int
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(ColorChoice.choices.values) { colorChoice in
                Button {
                    selectedColorChoiceId = colorChoice.id
                } label: {
                    ZStack {
                        ColorCircle(primaryColor: colorChoice.primaryColor, secondaryColor: colorChoice.secondaryColor)
                            .frame(width: 60)
                        
                        if colorChoice.id == selectedColorChoiceId {
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
        .sensoryFeedback(.impact, trigger: selectedColorChoiceId)
    }
}

#Preview {
    ChooseColorView(selectedColorChoiceId: .constant(0))
}
