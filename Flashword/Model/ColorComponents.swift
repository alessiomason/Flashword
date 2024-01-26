//
//  ColorComponents.swift
//  Flashword
//
//  Created by Alessio Mason on 25/01/24.
//

import SwiftUI

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float
    
    init(color: Color) {
        let resolvedColor = color.resolve(in: EnvironmentValues())
        self.red = resolvedColor.red
        self.green = resolvedColor.green
        self.blue = resolvedColor.blue
    }
    
    init(resolvedColor: Color.Resolved) {
        self.red = resolvedColor.red
        self.green = resolvedColor.green
        self.blue = resolvedColor.blue
    }
}

extension Color {
    init(colorComponents: ColorComponents) {
        let red = Double(colorComponents.red)
        let green = Double(colorComponents.green)
        let blue = Double(colorComponents.blue)
        
        self.init(red: red, green: green, blue: blue)
    }
}
