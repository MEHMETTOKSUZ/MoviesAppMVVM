//
//  FavoriteManager.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 7.01.2024.
//

import Foundation

class FavoriteManager {
    
    static let shared = FavoriteManager()
    private init() {}
    
    let favoriteKey = "FavoritesMovies"
    let userdefaults = UserDefaults.standard
    var favorites: [Results] = []
    
    func loadFavoriteMovies() {
        
        if let data = userdefaults.data(forKey: favoriteKey),
           let favorite = try? JSONDecoder().decode([Results].self, from: data) {
            self.favorites = favorite
            NotificationCenter.default.post(name: NSNotification.Name("newMoviesAdded"), object: nil)
        }
    }
    
    func toogleFavorite(item: Results) {
        
        if let index = favorites.firstIndex(where: {$0.id == item.id}) {
            favorites.remove(at: index)
        } else {
            favorites.append(item)
        }
        savedFavorites()
        NotificationCenter.default.post(name: NSNotification.Name("newMoviesAdded"), object: nil)
    }
    
    func isFavorite(item: Results) -> Bool {
        return favorites.contains {$0.id == item.id}
        
    }
    
    func savedFavorites() {
        
        if let data = try? JSONEncoder().encode(favorites) {
            userdefaults.set(data, forKey: favoriteKey)
        }
    }
}
