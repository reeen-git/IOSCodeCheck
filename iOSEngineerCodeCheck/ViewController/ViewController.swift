//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var repository = [Repository]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundColor = .black
        searchBar.placeholder = "Githubのリポジトリを検索"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
    }
}

private extension ViewController {
    func setupNavigationController() {
        title = "Github"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
        
    func setupView() {
        guard let guide = view.rootSafeAreaLayoutGuide else { return }
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: "cellId")
        self.overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
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

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        view.endEditing(true)
        if searchWord.count != 0 {
            ApiCaller.shared.searchs(with: searchWord) { [weak self] result in
                switch result {
                case .success(let repository):
                    self?.repository = repository
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                case .failure(let error):
                    assertionFailure("error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? GitTableViewCell else { return UITableViewCell() }
        cell.configure(with: repository[indexPath.row])
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailViewController()
        self.navigationController?.pushViewController(detailView, animated: true)
        detailView.repository = repository[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
