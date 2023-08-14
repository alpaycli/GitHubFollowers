//
//  User.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import Foundation

struct User: Codable {
    let login: String
    var name: String?
    var location: String?
    var bio: String?
    let avatarUrl: String
    let htmlUrl: String
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date
}
