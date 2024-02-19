//
//  DictionaryView.swift
//  Flashword
//
//  Created by Alessio Mason on 18/01/24.
//

import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
    let term: String
    
    typealias UIViewControllerType = UIReferenceLibraryViewController
    
    func makeUIViewController(context: Context) -> UIReferenceLibraryViewController {
        print("Making the DictionaryView")
        return UIReferenceLibraryViewController(term: term)
    }
    
    func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: Context) {
        print("Updating the DictionaryView")
    }
}

#Preview {
    DictionaryView(term: "Swift")
        .ignoresSafeArea()
}
