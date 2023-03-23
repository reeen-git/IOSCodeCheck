//
//  SearchView.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/03/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit

//TODO: MVCを適用したい → ControllerからUI部分を分離させ、ロジックと繋げる

final class SearchView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
       // tableView.delegate = self
       // tableView.dataSource = self
        tableView.backgroundColor = .black
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
       // searchBar.delegate = self
        searchBar.backgroundColor = .black
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.placeholder = "Githubのリポジトリを検索"
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchView {
    
    func setupView() {
        guard let guide = superview?.rootSafeAreaLayoutGuide else { return }
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: "cellId")
        superview?.backgroundColor = .black
        superview?.addSubview(tableView)
        superview?.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.width.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.centerX.width.bottom.equalToSuperview()
        }
    }
}

