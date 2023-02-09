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
import Ink

final class DetailViewController: UIViewController {
    private var htmlData = ""
    
    private let avorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.1
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private let discriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .white
        return textView
    }()
    
    private let starsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let forkCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let createrLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .star)
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private let forkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .point3ConnectedTrianglepathDotted)
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private lazy var readMeView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.tintColor = .white
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        return webView
    }()
    
    private let backToReadMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("README", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(.none, action: #selector(goToReadMe), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemSymbol: .chevronBackward), for: .normal)
        button.addTarget(.none, action: #selector(goBackward), for: .touchUpInside)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemSymbol: .chevronForward), for: .normal)
        button.addTarget(.none, action: #selector(goFoward), for: .touchUpInside)
        return button
    }()
    
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.configuration = .gray()
        button.addTarget(.none, action: #selector(addToFavourites), for: .touchUpInside)
        return button
    }()
    
    private lazy var webButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backToReadMeButton, backButton, forwardButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.backgroundColor = .secondarySystemFill
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, discriptionTextView, countStackView, favoriteButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.spacing = 10
        return stackView
    }()
    
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let parser = MarkdownParser()
    private let favoriteView = FavoriteRepositoryViewController()
    var userDefaults = UserDefaults.standard
    var repositoryData = UserDefaults.standard.array(forKey: "repository") as? [Data] ?? [Data]()
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getReadMeData()
        isFavoriteButtonAlreadyTapped()
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

private extension DetailViewController {
    func setupViews() {
        setTexts()
        setImage()
        
        view.backgroundColor = .black
        self.overrideUserInterfaceStyle = .dark
        
        createStackView(imageView: starImage, label: starsCountLabel)
        createStackView(imageView: forkImage, label: forkCountLabel)
        view.addSubview(avorImageView)
        view.addSubview(createrLabel)
        view.addSubview(headerStackView)
        view.addSubview(readMeView)
        view.addSubview(webButtonStackView)
        
        guard let guide = view.rootSafeAreaLayoutGuide else { return }
        avorImageView.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.leading.equalToSuperview().offset(10)
        }
        
        createrLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avorImageView.snp.centerY)
            make.leading.equalTo(avorImageView.snp.trailing).offset(20)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(avorImageView.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
        }
        
        discriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(discriptionTextView.textInputView.snp.height)
            make.centerX.equalToSuperview()
        }
        
        readMeView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(20)
            make.leading.equalTo(headerStackView.snp.leading).offset(10)
            make.trailing.equalTo(headerStackView.snp.trailing).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        webButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(readMeView.snp.bottom).offset(10)
            make.bottom.equalTo(guide)
            make.leading.equalTo(headerStackView.snp.leading).offset(10)
            make.trailing.equalTo(headerStackView.snp.trailing).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    func setTexts() {
        guard let repository else { return }
        guard let createrName = repository.fullName.components(separatedBy: "/").first else { return }
        starsCountLabel.text = "\(repository.stargazersCount) Star"
        forkCountLabel.text = "\(repository.forksCount) フォーク"
        discriptionTextView.text = repository.description
        createrLabel.text = createrName
    }
    
    func setImage() {
        titleLabel.text = repository?.fullName
        if let imgURL = repository?.avatarImageUrl {
            URLSession.shared.dataTask(with: imgURL) { [weak self] (data, res, err) in
                guard let data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.avorImageView.image = image
                }
            }.resume()
        }
    }
    
    func createStackView(imageView: UIImageView, label: UILabel) {
        lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        countStackView.addArrangedSubview(stackView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
}

extension DetailViewController: WKUIDelegate {
    func getReadMeData() {
        guard let repository else { return }
        ApiCaller.shared.fetchReadme(repository: repository) { [weak self] content in
            self?.displayMarkdown(input: content)
        }
    }
    
    func displayMarkdown(input: String?) {
        if input != nil {
            guard let input else { return }
            guard let decodedData = Data(base64Encoded: input, options: .ignoreUnknownCharacters),
                  let markdown = String(data: decodedData, encoding: .utf8) else { return }
            let htmlBody = parser.parse(markdown).html
            self.htmlData = "<html><head><style>body {color: white;font-size:50px;} a {color: #82bbed;}</style></head><body>\(htmlBody)</body></html>"
        } else {
            self.htmlData = "<html><head><style>body {color: white;font-size: 40px;} </style></head><body> There is no README in this repository. </body></html>"
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.readMeView.loadHTMLString(self?.htmlData ?? "", baseURL: nil)
        }
    }
    
    @objc func goToReadMe(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            self?.readMeView.loadHTMLString(self?.htmlData ?? "", baseURL: nil)
        }
    }
    
    @objc func goBackward(_ sender: UIButton) {
        if readMeView.canGoBack {
            readMeView.goBack()
        }
    }
    
    @objc func goFoward(_ sender: UIButton) {
        if readMeView.canGoForward {
            readMeView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            readMeView.load(navigationAction.request)
        }
        return nil
    }
}

extension DetailViewController {
    @objc func addToFavourites() {
        guard let repository else { return }
        isFavoriteButtonAlreadyTapped()
        if let encodedData = try? JSONEncoder().encode(repository) {
            repositoryData.append(encodedData)
            userDefaults.set(repositoryData, forKey: "repository")
        }
        NotificationCenter.default.post(name: Notification.Name("favoritesUpdated"), object: nil)
    }
    
    func isFavoriteButtonAlreadyTapped() {
        guard let repository else { return }
        let repositoryId = repository.id
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        
        if favorites.contains(repositoryId) {
            self.favoriteButton.setTitle("お気に入りに追加済み", for: .normal)
            self.favoriteButton.isEnabled = false
            self.favoriteButton.isSelected = false
        } else {
            self.favoriteButton.setTitle("+ お気に入りに追加", for: .normal)
            favorites.append(repositoryId)
            userDefaults.set(favorites, forKey: "favorites")
            userDefaults.post(name: Notification.Name("favoritesUpdated"), object: nil)
        }
    }
}
