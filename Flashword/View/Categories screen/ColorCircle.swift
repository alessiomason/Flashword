//
//  ColorCircle.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftUI

struct ColorCircle: View {
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(
                LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .shadow(radius: 4)
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 3)
            }
    }
}

#Preview("ColorCircle") {
    ColorCircle(primaryColor: .mint, secondaryColor: .blue)
}
