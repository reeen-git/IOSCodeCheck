//
//  MainNavigationController.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/08.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//
 
import UIKit
 
class MainNavigationController: UINavigationController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    } 
}
