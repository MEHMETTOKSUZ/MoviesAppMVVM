//
//  PaymentManeger.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 25.01.2024.
//

import Foundation

class PaymentManager {
    
    static let shared = PaymentManager()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    var purchased: [Results] = []
    let purchasedKey = "paymentSucces"
    
    
    func loadPurchasedItems() {
        if let data = userDefaults.data(forKey: purchasedKey),
           let items = try? JSONDecoder().decode([Results].self, from: data) {
            self.purchased = items
            NotificationCenter.default.post(name: NSNotification.Name("payment"), object: nil)
        }
    }
    
    func adToPurchaseData(item: Results) {
        if let index = purchased.firstIndex(where: { $0.id == item.id }) {
            purchased.remove(at: index)
        } else {
            purchased.append(item)
        }
        savedPurchasedtems()
        NotificationCenter.default.post(name: NSNotification.Name("payment"), object: nil)
    }

    
    func deletePurchaseMovie(_ movie: Results) {
        if let index = purchased.firstIndex(where: { $0.id == movie.id }) {
            purchased.remove(at: index)
        } else {
            print("error")
        }
        savedPurchasedtems()
        NotificationCenter.default.post(name: NSNotification.Name("payment"), object: nil)
    }
    
    func isPurchased(item: Results) -> Bool {
        return purchased.contains {$0.id == item.id}
    }
    
    func savedPurchasedtems() {
        if let data = try? JSONEncoder().encode(purchased) {
            userDefaults.set(data, forKey: purchasedKey)
            
        }
    }
    
    func saveCartItems(cartItems: [HomeTableViewCell.ViewModel]) {
        
           let encodedData = try? JSONEncoder().encode(purchased)
           userDefaults.set(encodedData, forKey: purchasedKey)
       }
}


