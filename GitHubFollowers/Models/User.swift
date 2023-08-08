//
//  User.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 07.08.23.
//

import Foundation

struct User: Codable {
    let login: String
    let name: String?
    let createdAt: String
}
