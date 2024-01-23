//
//  FlashwordApp.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

@main
struct LearnDictApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: Word.self)
    }
}
