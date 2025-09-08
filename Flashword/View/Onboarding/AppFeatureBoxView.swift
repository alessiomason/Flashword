//
//  AppFeatureBoxView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

struct AppFeatureBoxView: View {
    @ScaledMetric private var iconWidth = 60.0
    
    let image: Image
    let imageWeight: Font.Weight
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    
    var body: some View {
        HStack(alignment: .center) {
            image
                .resizable()
                .scaledToFit()
                .fontWeight(imageWeight)
                .frame(width: iconWidth)
                .foregroundStyle(.linearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(subtitle)
            }
            .padding(.trailing)
        }
        .padding(.bottom, 32)
    }
    
    init (title: LocalizedStringResource, subtitle: LocalizedStringResource, imageWeight: Font.Weight, @ViewBuilder _ image: () -> Image) {
        self.title = title
        self.subtitle = subtitle
        self.imageWeight = imageWeight
        self.image = image()
    }
}

#Preview {
    AppFeatureBoxView(title: "Words", subtitle: "Save words, look up their definitions, and more!", imageWeight: .regular) {
        Image(systemName: "books.vertical")
    }
}
