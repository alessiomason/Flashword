//
//  ColorChoice.swift
//  Flashword
//
//  Created by Alessio Mason on 31/01/24.
//

import SwiftUI

struct ColorChoice: Equatable, Identifiable {
    let id = UUID()
    let primaryColor: Color
    let secondaryColor: Color
    
    static let colorChoices = [
        ColorChoice(primaryColor: .mint, secondaryColor: .blue),
        ColorChoice(primaryColor: .yellow, secondaryColor: .red),
        ColorChoice(primaryColor: .purple, secondaryColor: .indigo),
        ColorChoice(primaryColor: .green, secondaryColor: Color(red: 0.118, green: 0.439, blue: 0.412))
    ]
}
