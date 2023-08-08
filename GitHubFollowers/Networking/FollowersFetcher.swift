//
//  FollowersFetcher.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import Foundation

class FollowersFetcher {
    static let shared = FollowersFetcher()
    private init() { }
    
    private var baseUrl = "https://api.github.com/users/"
    
    let manager = NetworkManager()
    
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
