//
//  Router.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

enum RouterDestination: Hashable {
    case allWordsCategory
    case category(category: Category)
    case word(word: Word)
}

@Observable
class Router {
    var path = [RouterDestination]()
}
