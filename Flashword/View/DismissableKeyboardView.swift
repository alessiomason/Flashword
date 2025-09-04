//
//  DismissableKeyboardView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

/// A view that presents a dismiss keyboard button whenever a keyboard is presented.
// Cannot use a toolbar item as there is currently no way to pad it away
// from the keyboard itself.
struct DismissableKeyboardView<Content: View>: View {
    @ScaledMetric private var buttonHeight = 8.0
    
    @Environment(\.keyboardShowing) private var keyboardShowing
    let content: Content
    
    init (@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        #if os(macOS)
            content
        #else
            ZStack {
                content
                
                if keyboardShowing {
                    HStack {
                        Spacer()
                        
                        Button(action: hideKeyboard) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .padding(.vertical, buttonHeight)   // make the button a circle and not a capsule
                        }
                        .accessibilityLabel(Text("Dismiss keyboard"))
                        .buttonStyle(.glass)
                        .padding(.trailing)
                    }
                    .padding(.bottom, 8)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .animation(.default, value: keyboardShowing)
        #endif
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    DismissableKeyboardView {
        Text("Hello, World!")
    }
}
