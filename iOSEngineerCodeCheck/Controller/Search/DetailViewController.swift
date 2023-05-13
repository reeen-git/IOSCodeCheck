//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import WebKit
import SFSafeSymbols

final class DetailViewController: UIViewController {
    private var htmlData = ""
    private let repositoryManager = RepositoryManager()
    private let detailView = DetailView()
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFavoriteButton()
        setupButtonAction()
        getReadMeData()
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

@MainActor
private extension DetailViewController {
    func setupViews() {
        Task {
            await setImage()
        }
        
        detailView.frame = view.bounds
        view.addSubview(detailView)
        detailView.readMeView.uiDelegate = self
        detailView.setTexts(repository)
    }
    
    func setupButtonAction() {
        detailView.backToReadMeButton.addTarget(.none, action: #selector(goToReadMe), for: .touchUpInside)
        detailView.backButton.addTarget(.none, action: #selector(goBackward), for: .touchUpInside)
        detailView.forwardButton.addTarget(.none, action: #selector(goFoward), for: .touchUpInside)
        detailView.favoriteButton.addTarget(.none, action: #selector(addToFavourites), for: .touchUpInside)
    }
    
    func setupNavigationController() {
        title = "Search"
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
    
    func setImage() async {
        guard let repository else { return }
        do {
            let image = try await repositoryManager.loadImage(url: repository.avatarImageUrl)
            self.detailView.avorImageView.image = image
        } catch {
            print("error")
        }
    }
}

//MARK: - WKUIDelegateのメゾット

extension DetailViewController: WKUIDelegate {
    func getReadMeData() {
        guard let repository else { return }
        Task {
            await getRepositoryData(repository)
        }
    }
    
    func getRepositoryData(_ repo: Repository) async {
        do {
            let data = try await ApiCaller.shared.fetchReadme(repository: repo)
            displayMarkdown(input: data)
        } catch {
            print("error")
        }
    }
    
    func displayMarkdown(input: String?) {
        htmlData = repositoryManager.decodeReadmeData(input)
        detailView.readMeView.loadHTMLString(htmlData , baseURL: nil)
    }
    
    @objc func goToReadMe(_ sender: UIButton) {
        detailView.readMeView.loadHTMLString(htmlData , baseURL: nil)
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
        detailView.favoriteButton.setTitle("お気に入り済み", for: .normal)
        detailView.favoriteButton.isEnabled = false
    }
    
    private func setupFavoriteButton() {
        guard let repository else { return }
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if favorites.contains(repository.id) {
            detailView.favoriteButton.setTitle("お気に入り済み", for: .normal)
            detailView.favoriteButton.isEnabled = false
        } else {
            detailView.favoriteButton.setTitle("+ お気に入りに追加", for: .normal)
        }
    }
}
