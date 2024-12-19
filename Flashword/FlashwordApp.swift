//
//  FlashwordApp.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

@main
struct FlashwordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: Word.self)
    }
}
