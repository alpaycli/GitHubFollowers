//
//  PersistenceMana.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 12.08.23.
//

import Foundation

enum ActionType {
    case add
    case remove
}

class PersistenceManager {
    static let shared = PersistenceManager()
    private init() { }
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites"
    
    func updateWith(_ favoriteItem: Follower, actionType: ActionType, completion: @escaping(GFError?) -> Void ) {
        loadFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    if favorites.contains(favoriteItem) {
                        completion(.alreadyInFavorite)
                        return
                    }
                    
                    favorites.append(favoriteItem)
                case .remove:
                    favorites.removeAll(where: { $0.login == favoriteItem.login } )
                }
                
                completion(self.saveFavorites(followers: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }

    
    func loadFavorites(completion: @escaping(Result<[Follower], GFError>) -> Void) {
        guard let data = defaults.object(forKey: favoritesKey) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedItems = try decoder.decode([Follower].self, from: data)
            completion(.success(decodedItems))
        } catch {
            completion(.failure(.unableToComplete))
        }
    }
    
    private func saveFavorites(followers: [Follower]) -> GFError? {
                
        do {
            let encoder = JSONEncoder()
            let encodedItems = try encoder.encode(followers)
            defaults.set(encodedItems, forKey: favoritesKey)
            return nil
        } catch {
            return .unableToComplete
        }
    }
}
