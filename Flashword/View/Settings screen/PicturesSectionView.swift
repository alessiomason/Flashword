//
//  PicturesSectionView.swift
//  Flashword
//
//  Created by Alessio Mason on 04/09/25.
//

import SwiftUI

struct PicturesSectionView: View {
    var body: some View {
        HStack {
            Image(.alessio2021)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.25
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 8)
            
            Image(.flashwordIcon)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.25
                }
                .padding(.horizontal, 8)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    PicturesSectionView()
}
