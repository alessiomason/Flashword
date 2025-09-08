//
//  KeyboardVisibility.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import Combine
import SwiftUI

public extension View {
    
    /// Sets an environment value for keyboardShowing.
    /// Access this in any child view with @Environment(\\.keyboardShowing) var keyboardShowing
    func addKeyboardVisibilityToEnvironment() -> some View {
        modifier(KeyboardVisibility())
    }
}

private struct KeyboardShowingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var keyboardShowing: Bool {
        get { self[KeyboardShowingEnvironmentKey.self] }
        set { self[KeyboardShowingEnvironmentKey.self] = newValue }
    }
}

private final class KeyboardMonitor: ObservableObject {
    @Published var isKeyboardShowing: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
#if os(macOS)
        // Not needed, keyboard not shown
#else
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .assign(to: \.isKeyboardShowing, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
            .assign(to: \.isKeyboardShowing, on: self)
            .store(in: &cancellables)
#endif
    }
}

private struct KeyboardVisibility: ViewModifier {
    @StateObject private var keyboardMonitor = KeyboardMonitor()
    
    fileprivate func body(content: Content) -> some View {
        content
            .environment(\.keyboardShowing, keyboardMonitor.isKeyboardShowing)
    }
}
