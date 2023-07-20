//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    private var repository = [Repository]()
    private var searchView = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationController()
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

private extension SearchViewController {
    func setupViews() {
        searchView.setupDelegates(self)
        searchView.frame = view.bounds
        view.addSubview(searchView)
    }

    func setupNavigationController() {
        title = "Search"
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
}

//MARK: - UISearchBarDelegate

@MainActor
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text,
              let searchEncodeString = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }

        view.endEditing(true)

        Task {
            await apiCall(searchEncodeString)
        }
    }

    func apiCall(_ text: String) async {
        do {
            let result = try await ApiCaller.shared.searchs(with: text)
            self.repository = result
            searchView.tableView.reloadData()
            searchView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } catch {
            print("error")
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
        navigationController?.pushViewController(detailView, animated: true)
        detailView.repository = repository[indexPath.row]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
