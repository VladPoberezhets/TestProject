//
//  NavigationTitleView.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import UIKit

final class NavigationTitleView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.textColor = UIColor(named: "highlightedOrange")
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        
        setupStackView()
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.imageView)
        
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupImageView() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func changeTitle(with text: String) {
        self.titleLabel.text = text
    }
}

