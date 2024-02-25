//
//  FavoriteViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 7.01.2024.
//

import Foundation

class FavoriteViewModel: BaseViewModel {
 
    let favoriteKey = "FavoritesMovies"

    func loadFavorites() {
        
        if let data = UserDefaults.standard.data(forKey: favoriteKey),
           let favorite = try? JSONDecoder().decode([Results].self, from: data) {
            self.presentMovies(item: favorite)
            didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Favoriler yüklenemedi")
        }
    }
}
