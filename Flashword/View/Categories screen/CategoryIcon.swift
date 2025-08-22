//
//  ColorCircle.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct CategoryIcon: View {
    @ScaledMetric private var iconHeight = 17.0
    
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
                .resizable()
                .scaledToFit()
                #if os(watchOS)
                .containerRelativeFrame(.vertical) { height, axis in
                    height * 0.32
                }
                #else
                .frame(height: iconHeight)
                #endif
                .foregroundStyle(.white)
        }
    }
}

struct ColorCircle: View {
    let primaryColor: Color
    let secondaryColor: Color
    
    @ScaledMetric private var circleHeight = 40.0
    
    var body: some View {
        Circle()
            #if !os(watchOS)
            .frame(height: circleHeight)
            #endif
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
