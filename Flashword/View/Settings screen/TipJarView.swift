//
//  TipJarView.swift
//  Flashword
//
//  Created by Alessio Mason on 20/12/24.
//

import RevenueCat
import SwiftUI

struct TipJarView: View {
    @State private var iapManager = IAPManager.shared
    @AppStorage("hasAlreadyTipped") private var hasAlreadyTipped = false
    
    var body: some View {
        List {
            if hasAlreadyTipped {
                Section {
                    VStack {
                        Text("🙏")
                            .font(.largeTitle)
                        
                        Text("Thank you so very much for your support!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            
            Section {
                if iapManager.loading {
                    ProgressView()
                        .controlSize(.large)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                ForEach(iapManager.packages) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(IAPManager.productName(for: product)).bold()
                            Text(IAPManager.productDescription(for: product))
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Button(product.localizedPriceString) {
                            Task {
                                let result = await iapManager.purchase(product: product)
                                if let result, !result.userCancelled {
                                    hasAlreadyTipped = true
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        //.tint(.teal)
                    }
                }
            }
        }
        .navigationTitle("🍯 Tip jar")
        .animation(.default, value: iapManager.loading)
        .animation(.easeInOut, value: hasAlreadyTipped)
    }
}

struct IAPRow: View {
    var product: Package
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.storeProduct.localizedTitle).bold()
                Text(product.storeProduct.localizedDescription)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Text(product.localizedPriceString).bold()
        }
        .foregroundColor(.primary)
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    TipJarView()
}
