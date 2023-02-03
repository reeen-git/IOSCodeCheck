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
    private let githubUrl = "https://api.github.com/search/repositories?q="
    var task: URLSessionTask?

    func searchs(with query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let decoder = JSONDecoder()
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        guard let urlString = URL(string: githubUrl + queryString) else { return }
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try decoder.decode(Articles.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}
