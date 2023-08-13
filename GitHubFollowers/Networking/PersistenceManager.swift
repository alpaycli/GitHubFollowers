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
    
    func updateWith(_ favoriteItem: Follower, actionType: ActionType, completion: @escaping(APIError?) -> Void ) {
        loadFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                
                switch actionType {
                case .add:
                    if retrievedFavorites.contains(favoriteItem) {
                        completion(.unknown)
                        return
                    }
                    
                    retrievedFavorites.append(favoriteItem)
                case .remove:
                    retrievedFavorites.removeAll(where: { $0.login == favoriteItem.login } )
                }
                
                completion(self.saveFavorites(followers: retrievedFavorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }

    
    func loadFavorites(completion: @escaping(Result<[Follower], APIError>) -> Void) {
        guard let data = defaults.object(forKey: favoritesKey) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedItems = try decoder.decode([Follower].self, from: data)
            completion(.success(decodedItems))
        } catch {
            completion(.failure(APIError.parsing(error as? DecodingError)))
        }
    }
    
    private func saveFavorites(followers: [Follower]) -> APIError? {
                
        do {
            let encoder = JSONEncoder()
            let encodedItems = try encoder.encode(followers)
            defaults.set(encodedItems, forKey: favoritesKey)
            return nil
        } catch {
            return APIError.unknown
        }
    }
}
