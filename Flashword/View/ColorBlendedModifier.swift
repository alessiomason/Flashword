//
//  TestingView.swift
//  Flashword
//
//  Created by Alessio Mason on 30/01/24.
//
// Code from https://ericasadun.com/2020/06/25/coloring-svg-assets-in-swiftui/

import SwiftUI

public struct ColorBlended: ViewModifier {
    fileprivate var color: Color
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                content
                color.blendMode(.sourceAtop)
            }
            .fixedSize(horizontal: false, vertical: true)
            .drawingGroup(opaque: false)
        }
    }
}

extension View {
    public func blending(color: Color) -> some View {
        modifier(ColorBlended(color: color))
    }
}

#Preview {
    VStack {
        Spacer()
        
        Image("Leaves and book")
            .resizable()
            .scaledToFit()
            .padding(10)
            .blending(color: .mint)
            .opacity(0.5)
    }
}
