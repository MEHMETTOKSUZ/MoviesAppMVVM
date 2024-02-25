//
//  CartViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import Foundation

class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    var addedToCart: [Results] = []
    let cartKey = "addedToCart"
    
    
    func loadCartItems() {
        if let data = userDefaults.data(forKey: cartKey),
           let items = try? JSONDecoder().decode([Results].self, from: data) {
            self.addedToCart = items
            NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
        }
    }
    
    func adToCart(item: Results) {
        if let index = addedToCart.firstIndex(where: {$0.id == item.id}) {
            addedToCart.remove(at: index)
        } else {
            addedToCart.append(item)
        }
        savedCartItems()
        NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
    }
    
    func deletePurchaseMovie(_ movie: Results) {
        if let index = addedToCart.firstIndex(where: { $0.id == movie.id }) {
            addedToCart.remove(at: index)
        } else {
            print("error")
        }
        savedCartItems()
        NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
    }
    
    func isAdedCart(item: Results) -> Bool {
        return addedToCart.contains {$0.id == item.id}
    }
    
    func savedCartItems() {
        if let data = try? JSONEncoder().encode(addedToCart) {
            userDefaults.set(data, forKey: cartKey)
            
        }
    }
    
    func calculateTotalPrice() -> (purchaseTotal: Double, rentTotal: Double) {
            let purchaseTotal = Double(addedToCart.count) * 2.99
            let rentTotal = Double(addedToCart.count) * 0.99
            return (purchaseTotal, rentTotal)
        }
    
    func removeAllItems() {
            addedToCart.removeAll()
            savedCartItems()
            NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
        }
}
