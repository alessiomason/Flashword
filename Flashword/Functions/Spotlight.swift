//
//  Spotlight.swift
//  Flashword
//
//  Created by Alessio Mason on 19/12/24.
//

import CoreSpotlight
import SwiftData

@Sendable func indexWords(modelContext: ModelContext, alreadyUpdatedWordsUuid: Bool = true) {
    let descriptor = FetchDescriptor<Word>(
        predicate: #Predicate { word in
            word.spotlightIndexed == false
        }
    )
    guard let words = try? modelContext.fetch(descriptor) else { return }
    
    var searchableItems = [CSSearchableItem]()
    
    for word in words {
        // This solves a bug with SwiftData's lightweight migration:
        // if some words were already present when updating to the new model with the UUID (previously absent),
        // all words were updated with the same UUID.
        // This creates a unique UUID for every word, only at first launch.
        if !alreadyUpdatedWordsUuid {
            word.uuid = UUID()
        }
        
        let searchableItem = word.createSpotlightSearchableItem()
        searchableItems.append(searchableItem)
        word.spotlightIndexed = true
    }
    
    CSSearchableIndex.default().indexSearchableItems(searchableItems)
}

func deleteSpotlightIndex(modelContext: ModelContext) {
    CSSearchableIndex.default().deleteAllSearchableItems()
    
    let descriptor = FetchDescriptor<Word>(
        predicate: #Predicate { word in
            word.spotlightIndexed == true
        }
    )
    guard let words = try? modelContext.fetch(descriptor) else { return }
    for word in words {
        word.spotlightIndexed = false
    }
}

func handleSpotlight(userActivity: NSUserActivity, modelContext: ModelContext, router: Router) {
    guard let string = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
    guard let queryUuid = UUID(uuidString: string) else { return }
    
    let descriptor = FetchDescriptor<Word>(
        predicate: #Predicate<Word> { word in
            word.uuid == queryUuid
        }
    )
    
    guard let word = try? modelContext.fetch(descriptor).first else { return }
    router.path.append(RouterDestination.word(word: word))
}
