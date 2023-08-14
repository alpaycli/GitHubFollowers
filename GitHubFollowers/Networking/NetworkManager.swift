//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
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
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(APIError.parsing(error as? DecodingError)))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(urlString: String, completion: @escaping(UIImage?) -> Void ) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(image)
        }
        
        task.resume()
        
    }
}


//class NetworkManager {
//
//    func fetch<T: Decodable>(_ type: T.Type, url: URLRequest?, completion: @escaping(Result<T, APIError>) -> Void) {
//
//        guard let url = url else {
//            let error = APIError.badURL
//            completion(Result.failure(error))
//            return
//        }
//
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            if let error = error as? URLError {
//                completion(Result.failure(APIError.url(error)))
//            }
//
//
//            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
//                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
//            }
//
//
//            if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                    let decodedItems = try decoder.decode(type, from: data)
//                    completion(Result.success(decodedItems))
//                } catch {
//                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
//                }
//            }
//
//        }
//        task.resume()
//
//    }
//
//}

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // for user
        switch self {
        case .badURL, .parsing, .unknown:
            return "Something went wrong"
        case .badResponse(_):
            return "Sorry, your connection lost with our server"
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        // for debugging
        switch self {
        case .badURL:
            return "Invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with \(statusCode)"
        case .url(let error):
            return error?.localizedDescription ?? "url session over"
        case .unknown:
            return "Something went wrong"
        }
    }
}
