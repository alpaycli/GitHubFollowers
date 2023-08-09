//
//  FollowersFetcher.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import UIKit

class FollowersFetcher {
    static let shared = FollowersFetcher()
    private init() { }
    
    let cache = NSCache<NSString, UIImage>()
    
    private var baseUrl = "https://api.github.com/users/"
    
    private let manager = NetworkManager()
    
    func fetchFollowers(for username: String, page: Int) {
        let endpoint = baseUrl + "\(username)/followers"
        let url = URLRequest(url: URL(string: endpoint)!)
        
        print(url)
        
        manager.fetch([Follower].self, url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let followers):
                print(followers)
            }
            
        }
    }
}
