//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Sean Allen on 1/2/20.
//  Copyright © 2020 Sean Allen. All rights reserved.
//

import UIKit

class FollowersFetcher {
    static let shared = FollowersFetcher()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], APIError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(APIError.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(APIError.badURL))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completed(.failure(APIError.badResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completed(.failure(APIError.url(error as? URLError)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(APIError.parsing(error as? DecodingError)))
            }
        }
        
        task.resume()
    }
}
