//
//  RepositoryManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
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
}
