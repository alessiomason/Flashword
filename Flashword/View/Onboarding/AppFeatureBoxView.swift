//
//  AppFeatureBoxView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

struct AppFeatureBoxView: View {
    @ScaledMetric private var iconWidth = 60.0
    
    let systemImageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth)
                .blendingHorizontally(color: .blue)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(subtitle)
            }
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    AppFeatureBoxView(systemImageName: "1.circle", title: "Words", subtitle: "Save words, look up their definitions, and more!")
}
