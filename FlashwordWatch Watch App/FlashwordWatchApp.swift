//
//  FlashwordWatchApp.swift
//  FlashwordWatch Watch App
//
//  Created by Alessio Mason on 15/05/24.
//

import SwiftData
import SwiftUI

@main
struct FlashwordWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: Word.self)
    }
}
