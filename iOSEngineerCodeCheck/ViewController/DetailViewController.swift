//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit
import SFSafeSymbols

final class DetailViewController: UIViewController {
    var repository: Repository?
    
    private let avorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
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
        textView.font = .systemFont(ofSize: 17, weight: .regular)
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
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private let forkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .point3ConnectedTrianglepathDotted)
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, languageLabel, discriptionTextView, countStackView])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        getImage()
        setupViews()
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

private extension DetailViewController {
    func setupViews() {
        view.backgroundColor = .black
        navigationController?.isToolbarHidden = true
        self.overrideUserInterfaceStyle = .dark
        
        guard let guide = view.rootSafeAreaLayoutGuide else { return }
        createStackView(imageView: starImage, label: starsCountLabel)
        createStackView(imageView: forkImage, label: forkCountLabel)
        view.addSubview(avorImageView)
        view.addSubview(createrLabel)
        view.addSubview(headerStackView)
        
        avorImageView.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.leading.equalToSuperview().offset(5)
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
    }
    
    func setTexts() {
        guard let repository else { return }
        guard let createrName = repository.fullName.components(separatedBy: "/").first else { return }
        languageLabel.text = "Written in \(repository.language ?? "")"
        starsCountLabel.text = "\(repository.stargazersCount) Star"
        forkCountLabel.text = "\(repository.forksCount) フォーク"
        discriptionTextView.text = repository.description
        createrLabel.text = createrName
    }
    
    func getImage(){
        titleLabel.text = repository?.fullName
        if let imgURL = repository?.avatarImageUrl {
            URLSession.shared.dataTask(with: imgURL) { (data, res, err) in
                guard let data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.avorImageView.image = image
                }
            }.resume()
        }
    }
    
    func createStackView(imageView: UIImageView, label: UILabel) {
        lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        countStackView.addArrangedSubview(stackView)
    }
}
