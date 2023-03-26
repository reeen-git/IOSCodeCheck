//
//  DetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/03/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

final class DetailView: UIView {
    let avorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.1
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    let discriptionTextView: UITextView = {
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
    
    let starsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let forkCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let createrLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .star)
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    let forkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemSymbol: .point3ConnectedTrianglepathDotted)
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    lazy var readMeView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.tintColor = .white
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    let backToReadMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("README", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemSymbol: .chevronBackward), for: .normal)
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemSymbol: .chevronForward), for: .normal)
        return button
    }()
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.configuration = .gray()
        return button
    }()
    
    lazy var webButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backToReadMeButton, backButton, forwardButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.backgroundColor = .secondarySystemFill
        return stackView
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, discriptionTextView, countStackView, favoriteButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.spacing = 10
        return stackView
    }()
    
    let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailView {
    func setupViews() {
        createStackView(imageView: starImage, label: starsCountLabel)
        createStackView(imageView: forkImage, label: forkCountLabel)
        addSubview(avorImageView)
        addSubview(createrLabel)
        addSubview(headerStackView)
        addSubview(readMeView)
        addSubview(webButtonStackView)
        
        guard let guide = self.rootSafeAreaLayoutGuide else { return }
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
    
    func createStackView(imageView: UIImageView, label: UILabel) {
        lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        countStackView.addArrangedSubview(stackView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
}
