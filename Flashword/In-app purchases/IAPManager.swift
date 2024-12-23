//
//  IAPManager.swift
//  Flashword
//
//  Created by Alessio Mason on 20/12/24.
//

import RevenueCat
import SwiftUI

@Observable
class IAPManager {
    static let shared = IAPManager()
    
    var loading = true
    var packages: [Package] = []
    var inProgressPayment = false
    
    init() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        
        Purchases.configure(withAPIKey: "appl_ihZyZqLjDxLHVddcQMXPJsSxVUy")
        
        Purchases.shared.getOfferings { (offerings, _error) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
                self.loading = false
            }
        }
    }
    
    func purchase(product: Package) async -> PurchaseResultData? {
        guard !inProgressPayment else { return nil }
        inProgressPayment = true
        
        do {
            return try await Purchases.shared.purchase(package: product)
        } catch {
            return nil
        }
    }
    
    static func productName(for product: Package) -> String {
        switch product.identifier {
            case "tip":
                return String(localized: "☕️ Buy me a coffee")
            default:
                return String(localized: "Tip")
        }
    }
    
    static func productDescription(for product: Package) -> String {
        switch product.identifier {
            case "tip":
                return String(localized: "A small tip to support the development of the app.")
            default:
                return String(localized: "A tip to support the development of the app.")
        }
    }
}
