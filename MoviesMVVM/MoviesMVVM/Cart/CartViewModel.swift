//
//  CartViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import Foundation

class CartViewModel: BaseViewModel {
    
    let cartKey = "addedToCart"
    
    func loadCartItems() {
        
        if let data = UserDefaults.standard.data(forKey: cartKey),
           let cartItems = try? JSONDecoder().decode([Results].self, from: data) {
            self.presentMovies(item: cartItems)
            didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Cart verileri yüklenemedi")
        }
    }
}
