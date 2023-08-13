//
//  UserFetcher.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 11.08.23.
//

import Foundation

class UserFetcher {
    static let shared = UserFetcher()
    private let baseURL = "https://api.github.com/users/"
    
    private init() { }

    
    func getUser(for username: String, completion: @escaping (Result<User, APIError>) -> Void) {
        let endpoint = baseURL + username
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.badURL))
            return
        }
        

        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(APIError.badURL))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(APIError.badResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.url(error as? URLError)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(APIError.parsing(error as? DecodingError)))
            }
        }
        
        task.resume()
    }

}
