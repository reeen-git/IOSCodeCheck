//
//  RepositoryManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import Ink

final class RepositoryManager {
    private var repositoryData = UserDefaults.standard.array(forKey: "repository") as? [Data] ?? [Data]()
    private let parser = MarkdownParser()
    
    func setUserDefaults(_ repository: Repository) {
        guard let encodedData = try? JSONEncoder().encode(repository) else { return }
        repositoryData.append(encodedData)
        UserDefaults.standard.set(repositoryData, forKey: "repository")
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        favorites.append(repository.id)
        UserDefaults.standard.set(favorites, forKey: "favorites")
        
        NotificationCenter.default.post(name: Notification.Name("favoritesUpdated"), object: nil)
    }
    
    func decodeReadmeData(_ input: String?) -> String {
        var htmlData = ""
        if input != nil {
            guard let input = input,
                  let decodedData = Data(base64Encoded: input, options: .ignoreUnknownCharacters),
                  let markdown = String(data: decodedData, encoding: .utf8) else { return "" }
            let htmlBody = parser.parse(markdown).html
            htmlData = "<html><head><style>body {color: white;font-size:50px;} a {color: #82bbed;}</style></head><body>\(htmlBody)</body></html>"
        } else {
            htmlData = "<html><head><style>body {color: white;font-size: 40px;} </style></head><body> There is no README in this repository. </body></html>"
        }
        return htmlData
    }
    
    func setCircleColor(_ language: String?) -> UIColor {
        guard let language else { return .yellow }
        if language == "Swift" {
            return .orange
        } else if language == "C++" {
            return .systemPink
        } else if language == "Python" {
            return .blue
        } else if language == "C" {
            return .darkGray
        } else if language == "Ruby" {
            return .red
        } else if language == "GO" {
            return .cyan
        } else if language == "Kotlin" {
            return .purple
        } else {
            return .yellow
        }
    }
    
    func loadImage(url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
