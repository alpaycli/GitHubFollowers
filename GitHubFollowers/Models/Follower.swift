//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
}
