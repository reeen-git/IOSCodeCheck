//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SFSafeSymbols

final class DetailViewController: UIViewController {
    private var htmlData = ""
    private let repositoryManager = RepositoryManager()
    private let detailView = DetailView()
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteButton()
        getReadMeData()
    }
}


//MARK: - WKUIDelegateのメゾット

extension DetailViewController: WKUIDelegate {
    func getReadMeData() {
        guard let repository else { return }
        Task {
            await self.getRepositoryData(repository)
        }
    }
    
    func getRepositoryData(_ repo: Repository) async {
        do {
            let data = try await ApiCaller.shared.fetchReadme(repository: repo)
            self.displayMarkdown(input: data)
        } catch {
            print("error")
        }
    }
    
    func displayMarkdown(input: String?) {
        self.htmlData = repositoryManager.decodeReadmeData(input)
        DispatchQueue.main.async { [weak self] in
            self?.detailView.readMeView.loadHTMLString(self?.htmlData ?? "", baseURL: nil)
        }
    }
    
    @objc func goToReadMe(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            self?.detailView.readMeView.loadHTMLString(self?.htmlData ?? "", baseURL: nil)
        }
    }
    
    @objc func goBackward(_ sender: UIButton) {
        if detailView.readMeView.canGoBack {
            detailView.readMeView.goBack()
        }
    }
    
    @objc func goFoward(_ sender: UIButton) {
        if detailView.readMeView.canGoForward {
            detailView.readMeView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            detailView.readMeView.load(navigationAction.request)
        }
        return nil
    }
}

//MARK: - お気に入りリポジトリ追加機能部分

private extension DetailViewController {
    @objc func addToFavourites() {
        guard let repository else { return }
        repositoryManager.setUserDefaults(repository)
        self.detailView.favoriteButton.setTitle("お気に入り済み", for: .normal)
        self.detailView.favoriteButton.isEnabled = false
    }
    
    private func setupFavoriteButton() {
        guard let repository else { return }
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if favorites.contains(repository.id) {
            self.detailView.favoriteButton.setTitle("お気に入り済み", for: .normal)
            self.detailView.favoriteButton.isEnabled = false
        } else {
            self.detailView.favoriteButton.setTitle("+ お気に入りに追加", for: .normal)
        }
    }
}
