//
//  MainViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/08.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        let searchViewController = MainNavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: .none, tag: 0)
        
        let favoriteRepositoryViewController = MainNavigationController(rootViewController: FavoriteRepositoryViewController())
        favoriteRepositoryViewController.tabBarItem = UITabBarItem(title: "Favorite", image: .none, tag: 1)

        viewControllers = [searchViewController, favoriteRepositoryViewController]
        setViewControllers(viewControllers, animated: false)
    }
}
