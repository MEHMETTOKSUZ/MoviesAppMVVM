//
//  PurchasedViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 17.02.2024.
//

import Foundation

class PurchasedViewModel: BaseViewModel {
    
    let key = "paymentSucces"
    
    func loadPurchasedItem() {
        
        if let data = UserDefaults.standard.data(forKey: key),
           let purchased = try? JSONDecoder().decode([Results].self, from: data) {
            self.presentMovies(item: purchased)
            self.didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Satın alınanlar yüklenemedi")
        }
    }
    
}
