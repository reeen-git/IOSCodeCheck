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
    
    func searchs(with query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        guard let searchUrl = URL(string: githubUrl + queryString) else { return }
        URLSession.shared.dataTask(with: searchUrl) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try self.decoder.decode(Articles.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchReadme(repository: Repository, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/readme") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                assertionFailure("\(error)")
                return
            }
            
            guard let data = data, let readmeResponse = try? JSONDecoder().decode(RepositoryReadme.self, from: data) else { return }
            completion(readmeResponse.content)
        }.resume()
    }

}
