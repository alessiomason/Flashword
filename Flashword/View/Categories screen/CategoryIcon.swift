//
//  ColorCircle.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct CategoryIcon: View {
    let category: Category?
    
    var primaryColor: Color {
        category?.primaryColor ?? .mint
    }
    var secondaryColor: Color {
        category?.secondaryColor ?? .blue
    }
    
    var image: Image {
        if let category {
            Image(systemName: category.symbol.rawValue)
        } else {
            Image(.customTraySlash)
        }
    }
    
    var body: some View {
        ZStack {
            ColorCircle(primaryColor: primaryColor, secondaryColor: secondaryColor)
            
            image
                #if os(watchOS)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.09
                }
                #endif
                .foregroundStyle(.white)
        }
    }
}

struct ColorCircle: View {
    let primaryColor: Color
    let secondaryColor: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(
                LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .shadow(radius: 4)
            .overlay {
                Circle()
                    #if os(watchOS)
                    .stroke(.white, lineWidth: 1)
                    #else
                    .stroke(.white, lineWidth: 3)
                    #endif
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        container.mainContext.insert(Category.example)
        
        return CategoryIcon(category: .example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
