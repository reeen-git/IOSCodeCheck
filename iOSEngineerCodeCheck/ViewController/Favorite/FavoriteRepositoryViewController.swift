//
//  FavoriteRepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/08.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit

final class FavoriteRepositoryViewController: UIViewController {
    lazy var favoriteTabiewView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var repositories: [Repository] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: Notification.Name("favoritesUpdated"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        loadFavoriteRepositorys()
        setupView()
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

private extension FavoriteRepositoryViewController {
    func setupNavigationController() {
        title = "Favorites"
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
    
    func loadFavoriteRepositorys() {
        if let repositoryData = UserDefaults.standard.array(forKey: "repository") as? [Data] {
            for data in repositoryData {
                if let repository = try? JSONDecoder().decode(Repository.self, from: data) {
                    self.repositories.append(repository)
                }
            }
        }
    }
    
    func setupView() {
        guard let guide = view.rootSafeAreaLayoutGuide else { return }
        favoriteTabiewView.register(GitTableViewCell.self, forCellReuseIdentifier: "cellId")
        self.overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        view.addSubview(favoriteTabiewView)
        
        favoriteTabiewView.snp.makeConstraints { make in
            make.edges.equalTo(guide)
        }
    }
    
    @objc func favoritesUpdated() {
        repositories.removeAll()
        self.loadFavoriteRepositorys()
        DispatchQueue.main.async {
            self.favoriteTabiewView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoriteRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? GitTableViewCell else { return UITableViewCell() }
        cell.configure(with: repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailViewController()
        navigationController?.pushViewController(detailView, animated: true)
        detailView.repository = repositories[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
