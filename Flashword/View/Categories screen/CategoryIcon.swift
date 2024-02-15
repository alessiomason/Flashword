//
//  ColorCircle.swift
//  Flashword
//
//  Created by Alessio Mason on 01/02/24.
//

import SwiftData
import SwiftUI

struct CategoryIcon: View {
    let category: Category
    
    var body: some View {
        ZStack {
            ColorCircle(primaryColor: category.primaryColor, secondaryColor: category.secondaryColor)
            
            Image(systemName: category.symbol.rawValue)
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
                    .stroke(.white, lineWidth: 3)
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
