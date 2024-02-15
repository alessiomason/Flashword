//
//  ColorChoice.swift
//  Flashword
//
//  Created by Alessio Mason on 31/01/24.
//

import OrderedCollections
import SwiftUI

struct ColorChoice: Equatable, Identifiable {
    let id: Int
    let primaryColor: Color
    let secondaryColor: Color
    
    static let choices: OrderedDictionary = [
        0: ColorChoice(id: 0, primaryColor: .mint, secondaryColor: .blue),
        1: ColorChoice(id: 1, primaryColor: .yellow, secondaryColor: .red),
        2: ColorChoice(id: 2, primaryColor: .purple, secondaryColor: .indigo),
        3: ColorChoice(id: 3, primaryColor: .green, secondaryColor: Color(red: 0.118, green: 0.439, blue: 0.412))
    ]
}
