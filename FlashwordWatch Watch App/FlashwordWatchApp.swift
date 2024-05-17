//
//  FlashwordWatchApp.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

@main
struct FlashwordWatchApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: Word.self)
    }
}
