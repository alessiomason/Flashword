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
    let tintColor: Color    // color used for text and as the tint color
    
    static let choices: OrderedDictionary = [
        0: ColorChoice(
            id: 0,
            primaryColor: .mint,
            secondaryColor: .blue,
            tintColor: .blue
        ),
        1: ColorChoice(
            id: 1,
            primaryColor: .yellow,
            secondaryColor: .red,
            tintColor: .red
        ),
        2: ColorChoice(
            id: 2,
            primaryColor: .green,
            secondaryColor: Color(red: 0.118, green: 0.439, blue: 0.412),
            tintColor: Color(red: 0.118, green: 0.439, blue: 0.412)
        ),
        3: ColorChoice(
            id: 3,
            primaryColor: .purple,
            secondaryColor: Color(red: 0.239, green: 0.000, blue: 0.400),
            tintColor: Color(red: 0.443, green: 0.000, blue: 0.749)
        ),
        4: ColorChoice(
            id: 4,
            primaryColor: Color(red: 0.945, green: 0.094, blue: 0.298),
            secondaryColor: Color(red: 0.659, green: 0.129, blue: 0.420),
            tintColor: Color(red: 0.659, green: 0.129, blue: 0.420)
        ),
        5: ColorChoice(
            id: 5,
            primaryColor: Color(red: 0.957, green: 0.271, blue: 0.376),
            secondaryColor: Color(red: 0.451, green: 0.020, blue: 0.090),
            tintColor: Color(red: 0.576, green: 0.025, blue: 0.113)
        ),
        6: ColorChoice(
            id: 6,
            primaryColor: Color(red: 1.000, green: 0.835, blue: 0.000),
            secondaryColor: Color(red: 1.000, green: 0.624, blue: 0.000),
            tintColor: Color(red: 1.000, green: 0.624, blue: 0.000)
        ),
        7: ColorChoice(
            id: 7,
            primaryColor: Color(red: 0.016, green: 0.400, blue: 0.784),
            secondaryColor: Color(red: 0.000, green: 0.208, blue: 0.400),
            tintColor: Color(red: 0.000, green: 0.300, blue: 0.580)
        ),
        8: ColorChoice(
            id: 8,
            primaryColor: Color(red: 1.000, green: 0.733, blue: 0.424),
            secondaryColor: Color(red: 0.831, green: 0.537, blue: 0.416),
            tintColor: Color(red: 0.831, green: 0.537, blue: 0.416)
        ),
        9: ColorChoice(
            id: 9,
            primaryColor: Color(red: 0.655, green: 0.925, blue: 0.949),
            secondaryColor: Color(red: 0.243, green: 0.612, blue: 0.749),
            tintColor: Color(red: 0.243, green: 0.612, blue: 0.749)
        ),
        10: ColorChoice(
            id: 10,
            primaryColor: Color(red: 0.196, green: 0.643, blue: 0.655),
            secondaryColor: Color(red: 0.118, green: 0.439, blue: 0.412),
            tintColor: Color(red: 0.118, green: 0.439, blue: 0.412)
        ),
        11: ColorChoice(
            id: 11,
            primaryColor: .purple,
            secondaryColor: .indigo,
            tintColor: .indigo
        )
    ]
}
