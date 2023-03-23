//
//  ApiCaller.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/03.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

final class ApiCaller {
    static let shared = ApiCaller()
    private let decoder = JSONDecoder()
    private let githubUrl = "https://api.github.com/search/repositories?q="
    
    func searchs(with query: String) async throws -> [Repository] {
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        guard let searchUrl = URL(string: githubUrl + queryString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: searchUrl)
        let result = try decoder.decode(Articles.self, from: data)
        return result.items
    }
    
    func fetchReadme(repository: Repository) async throws -> String? {
        guard let url = URL(string: "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/readme") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try decoder.decode(RepositoryReadme.self, from: data)
        return result.content
    }
    
}
