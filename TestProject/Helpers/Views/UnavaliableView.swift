//
//  UnavaliableView.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import UIKit

final class UnavaliableView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .black
        return view
    }()
    
    
    init(title: String, description: String, image: UIImage?) {
        super.init(frame: .zero)
        self.backgroundColor =  UIColor(named: "backgroundColor")
        self.imageView.image = image
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupImageView()
        setupTitleView()
        setupDescriptionView()
    }
    
    private func setupImageView() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -35),
            self.imageView.heightAnchor.constraint(equalToConstant: 70),
            self.imageView.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func setupTitleView() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
        ])
    }
    
    private func setupDescriptionView() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
        ])
    }
}

