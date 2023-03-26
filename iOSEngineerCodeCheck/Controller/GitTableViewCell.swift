//
//  GitTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/03.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import SnapKit

final class GitTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let createrLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private let starsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .star)
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let circleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .circleFill)
        return imageView
    }()
    
    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, titleLabel, subTitleLabel, countStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 7
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
    
    private let repositoryManager = RepositoryManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - viewDidLoad()で呼ばれるもの

private extension GitTableViewCell {
    func setupViews() {
        addSubview(entireStackView)
        addSubview(createrLabel)
        
        createStackView(imageView: starImage, label: starsCountLabel)
        createStackView(imageView: circleImage, label: languageLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        entireStackView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.centerX.equalToSuperview()
        }
        
        createrLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
        }
    }
    
    func createStackView(imageView: UIImageView, label: UILabel) {
        lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        countStackView.addArrangedSubview(stackView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
    }
    
    func makeImageTintColor(_ language: String?) {
        let circleImageTintColor = repositoryManager.setCircleColor(language)
        circleImage.tintColor = circleImageTintColor
    }
}

//MARK: - privateではないもの
extension GitTableViewCell {
    func configure(with repository: Repository) {
        createrLabel.text = repository.owner.login
        titleLabel.text = repository.name
        languageLabel.text = repository.language ?? "開発言語の記載なし"
        subTitleLabel.text = repository.description
        starsCountLabel.text = repository.stargazersCount.description
        makeImageTintColor(repository.language)
        
        Task {
            await getImageData(repository)
        }
    }
    
    func getImageData(_ repo: Repository) async {
        do {
            let image = try await repositoryManager.loadImage(url: repo.avatarImageUrl)
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        } catch {
            print("error")
        }
    }
}
