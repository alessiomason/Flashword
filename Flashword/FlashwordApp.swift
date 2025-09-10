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
    
    init() {
        // change title font fot the whole app to New York font
        let largeTitle = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        let regularTitle = UIFont.preferredFont(forTextStyle: .body)
        
        let descriptor = largeTitle.fontDescriptor.withDesign(.serif)!
        let largeFont = UIFont(descriptor: descriptor, size: largeTitle.pointSize)
        let regularFont = UIFont(descriptor: descriptor, size: regularTitle.pointSize)
        
        // for large title
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: largeFont]
        
        // for inline title
        UINavigationBar.appearance().titleTextAttributes = [.font: regularFont]
    }
}
