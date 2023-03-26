//
//  SearchView.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/03/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit

final class SearchView: UIView {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
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

extension SearchView {
    private func setupView() {
        guard let guide = self.rootSafeAreaLayoutGuide else { return }
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: "cellId")
        addSubview(tableView)
        addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.width.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.centerX.width.bottom.equalToSuperview()
        }
    }
    
    func setupDelegates(_ searchViewController: SearchViewController) {
        tableView.dataSource = searchViewController
        tableView.delegate = searchViewController
        searchBar.delegate = searchViewController
    }
}
