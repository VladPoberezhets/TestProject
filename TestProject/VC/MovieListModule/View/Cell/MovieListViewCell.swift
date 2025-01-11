//
//  MovieListViewCell.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation
import UIKit

final class MovieListViewCell: UICollectionViewCell {
    
    private var currentModelId: Int?
    
    static let identifier = "MovieListViewCell"
    
    private lazy var cellContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.alignment = .top
        view.distribution = .equalSpacing
        view.spacing = 20
        return view
    }()

    private lazy var backgroundImageView: UIImageView = {
         let view = UIImageView()
         view.contentMode = .scaleAspectFill
         view.clipsToBounds = true
         return view
     }()
     
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.textColor = UIColor(named: "backgroundColor")
        return view
     }()
    
    private lazy var reatingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        view.textColor = UIColor(named: "highlightedOrange")
        view.textAlignment = .right
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let color: UIColor = UIColor(named: "gradientColor") ?? .black
        layer.colors = [color.cgColor, color.withAlphaComponent(0).cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 1.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        return layer
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImageView.image = nil
        self.titleLabel.text = nil
        self.reatingLabel.text = nil
        self.currentModelId = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.setupViews()
    }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundImageView.bounds
    }
    
    private func setupViews() {
        self.setupBackgroundImageView()
        self.setupTitle()
        self.setupContentView()
        
        self.cellContentView.addArrangedSubview(self.reatingLabel)
    }
    
    private func setupBackgroundImageView() {
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupTitle() {
        self.backgroundImageView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -16),
        ])
    }

    private func setupContentView() {
        self.backgroundImageView.addSubview(self.cellContentView)
        self.cellContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.cellContentView.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor, constant: 16),
            self.cellContentView.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -16),
            self.cellContentView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -20)
        ])
    }
   
    
    func setup(model: MoviesListModel, presenter: MovieListPresenterProtocol) {
        guard currentModelId != model.id else { return }
        
        self.currentModelId = model.id
        
        self.backgroundImageView.showLoader()
        presenter.getImage(imagePath: model.imageUrl ?? "") { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let image {
                    self.backgroundImageView.layer.insertSublayer(self.gradientLayer, at: 0)
                    self.backgroundImageView.image = image
                   
                } else {
                    self.backgroundImageView.image = UIImage(named: "failedLoadImage")
                }
              
                self.titleLabel.text = "\(model.title ?? ""), \(model.releaseDate?.transformDateToYearString() ?? "")"
                self.backgroundImageView.hideLoader()
                self.reatingLabel.text = "\(String(localized: "RATING_TITLE")): \(Float(model.rating ?? 0))"
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.bounds.size.width = self.bounds.width
        attributes.bounds.size.height = self.bounds.height
        return attributes
    }
}
