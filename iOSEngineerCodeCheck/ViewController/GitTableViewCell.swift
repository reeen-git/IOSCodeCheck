//
//  GitTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/03.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

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
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let starsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private var avoterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .starFill)
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private let circleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .circleFill)
        return imageView
    }()
    
    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avoterImageView, titleLabel, subTitleLabel, countStackView])
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GitTableViewCell {
    private func setupViews() {
        addSubview(entireStackView)
        addSubview(createrLabel)
        
        createStackView(imageView: starImage, label: starsCountLabel)
        createStackView(imageView: circleImage, label: languageLabel)
        
        avoterImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        starImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
        entireStackView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.centerX.equalToSuperview()
        }
        
        createrLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avoterImageView)
            make.leading.equalTo(avoterImageView.snp.trailing).offset(10)
        }
    }
    
    private func createStackView(imageView: UIImageView, label: UILabel) {
        lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        countStackView.addArrangedSubview(stackView)
    }
    
    func configure(with repository: Repository) {
        guard let language = repository.language else { return }
        let fullName = repository.fullName.components(separatedBy: "/")
        createrLabel.text = fullName[0]
        titleLabel.text = fullName[1]
        languageLabel.text = language
        subTitleLabel.text = repository.description
        starsCountLabel.text = repository.stargazersCount.description
        makeImageTintColor(language)
        
        if let url = repository.avatarImageUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.avoterImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func makeImageTintColor(_ language: String) {
        if language == "Swift" {
            circleImage.tintColor = .orange
        } else if language == "Python" {
            circleImage.tintColor = .blue
        } else if language == "C" {
            circleImage.tintColor = .darkGray
        } else if language == "Ruby" {
            circleImage.tintColor = .red
        } else if language == "GO" {
            circleImage.tintColor = .cyan
        } else if language == "Kotlin" {
            circleImage.tintColor = .purple
        } else {
            circleImage.tintColor = .yellow
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        avoterImageView.image = nil
    }
}
