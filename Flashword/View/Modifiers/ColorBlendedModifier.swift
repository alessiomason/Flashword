//
//  TestingView.swift
//  Flashword
//
//  Created by Alessio Mason on 30/01/24.
//
// Code from https://ericasadun.com/2020/06/25/coloring-svg-assets-in-swiftui/

import SwiftUI

public struct ColorBlendedVerticallyConstrained: ViewModifier {
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

public struct ColorBlendedHorizontallyConstrained: ViewModifier {
    fileprivate var color: Color
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                content
                color.blendMode(.sourceAtop)
            }
            .fixedSize(horizontal: true, vertical: false)
            .drawingGroup(opaque: false)
        }
    }
}

extension View {
    public func blendingVertically(color: Color) -> some View {
        modifier(ColorBlendedVerticallyConstrained(color: color))
    }
    
    public func blendingHorizontally(color: Color) -> some View {
        modifier(ColorBlendedHorizontallyConstrained(color: color))
    }
}

#Preview {
    VStack {
        Spacer()
        
        Image(.leavesAndBook)
            .resizable()
            .scaledToFit()
            .padding(10)
            .blendingVertically(color: .mint)
            .opacity(0.5)
    }
}
