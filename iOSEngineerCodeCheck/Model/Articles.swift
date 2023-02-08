//
//  Articles.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/03.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Articles: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let fullName: String
    let name: String
    let language: String?
    let id: Int
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let description: String?
    let html: String
    
    let owner: Owner
    
    var avatarImageUrl: URL? {
        return URL(string: owner.avatarUrl)
    }

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case name = "name"
        case language = "language"
        case id = "id"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case description = "description"
        case owner = "owner"
        case html = "html_url"
    }
}

struct Owner: Codable {
    let avatarUrl: String
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login = "login"
    }
}

struct RepositoryReadme: Codable {
  let content: String?

  init(content: String?) {
    self.content = content
  }
}
