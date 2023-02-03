//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let starsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let watcherCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let forkCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let issueCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        getImage()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        guard let guide = view.rootSafeAreaLayoutGuide else { return }
        view.addSubview(entireStackView)

        entireStackView.snp.makeConstraints { make in
            make.edges.equalTo(guide)
        }
    }
    
    func setTexts() {
        guard let repository else { return }
        languageLabel.text = "Written in \(repository.language ?? "")"
        starsCountLabel.text = "\(repository.stargazersCount) stars"
        watcherCountLabel.text = "\(repository.watchersCount) watchers"
        forkCountLabel.text = "\(repository.forksCount) forks"
        issueCountLabel.text = "\(repository.openIssuesCount) open issues"
    }
    
    func getImage(){
        titlelabel.text = repository?.fullName
        if let imgURL = repository?.avatarImageUrl {
            URLSession.shared.dataTask(with: imgURL) { (data, res, err) in
                guard let data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume()
        }
    }
}
