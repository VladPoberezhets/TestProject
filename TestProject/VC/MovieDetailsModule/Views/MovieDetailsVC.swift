//
//  MovieDetailsVC.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation
import UIKit

protocol MovieDetailsVCProtocol: BaseUIViewControllerProtocol {
    func getModel(model: MovieDetailModel)
    func showError(_ message: String)
}

final class MovieDetailsVC: BaseUIViewController {
    private(set) var presenter: MovieDetailsPresenterProtocol!
    
    private var model: MovieDetailModel!
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
         let view = UIImageView()
         view.contentMode = .scaleAspectFill
         view.clipsToBounds = true
         view.isUserInteractionEnabled = true
         return view
     }()
    
    private lazy var posterButtonView: UIButton = {
        let view = UIButton()
        view.isEnabled = true
        view.addTarget(self, action: #selector(imageAction), for: .touchUpInside)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.textColor = UIColor(named: "titleColor")
        return view
     }()
    
    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.textColor = UIColor(named: "titleColor")
        return view
     }()
    
    private lazy var genresTitleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.textColor = UIColor(named: "titleColor")
        return view
     }()
    
    private lazy var videoButtonView: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "playImage"), for: .normal)
        view.isEnabled = true
        view.isHidden = true
        view.addTarget(self, action: #selector(vidoAction), for: .touchUpInside)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var reatingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.textColor = UIColor(named: "highlightedOrange")
        view.textAlignment = .right
        return view
    }()
    
    private lazy var overviewLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor(named: "titleColor")
        view.textAlignment = .center
        return view
    }()
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.setupNavigationTitle(image: UIImage(named: "navigationImage"), title: String(localized: "HEADER_TITLE"))
        setupViews()
        presenter.getMovieModel()
    }
    
    private func setupViews() {
        setupScrollView()
        setupContentView()
        setupPosterImageView()
        setupPosterButtonView()
        setupTitleLabel()
        setupSubTitleLabel()
        setupSubTitleLabel()
        setupGenresTitleLabel()
        setupVideoButtonView()
        setupReatingLabel()
        setupOverviewLabel()
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func setupPosterImageView() {
        self.contentView.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
    }
    
    private func setupPosterButtonView() {
        self.posterImageView.addSubview(self.posterButtonView)
        self.posterButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.posterButtonView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor),
            self.posterButtonView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor),
            self.posterButtonView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor),
            self.posterButtonView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor)
        ])
    }
    
    private func setupTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupSubTitleLabel() {
        self.contentView.addSubview(self.subTitleLabel)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupGenresTitleLabel() {
        self.contentView.addSubview(self.genresTitleLabel)
        self.genresTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.genresTitleLabel.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 18),
            self.genresTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.genresTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupVideoButtonView() {
        self.contentView.addSubview(self.videoButtonView)
        self.videoButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.videoButtonView.topAnchor.constraint(equalTo: self.genresTitleLabel.bottomAnchor, constant: 16),
            self.videoButtonView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.videoButtonView.heightAnchor.constraint(equalToConstant: 36),
            self.videoButtonView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupReatingLabel() {
        self.contentView.addSubview(self.reatingLabel)
        self.reatingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.reatingLabel.topAnchor.constraint(equalTo: self.genresTitleLabel.bottomAnchor, constant: 24),
            self.reatingLabel.leadingAnchor.constraint(equalTo: self.videoButtonView.leadingAnchor, constant: 16),
            self.reatingLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupOverviewLabel() {
        self.contentView.addSubview(self.overviewLabel)
        self.overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.overviewLabel.topAnchor.constraint(equalTo: self.videoButtonView.bottomAnchor, constant: 32),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.overviewLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupPresenter(_ presenter: MovieDetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    @objc private func imageAction() {
        self.presenter.didSelectImage(image: self.posterImageView.image)
    }
    
    @objc private func vidoAction() {
        self.presenter.didSeclectVideo(trailerKey: self.model.trailerKey)
    }
}

extension MovieDetailsVC: MovieDetailsVCProtocol {
    func getModel(model: MovieDetailModel) {
        DispatchQueue.main.async { [weak self] in
            self?.model = model
            self?.titleLabel.text = model.title
            self?.subTitleLabel.text = "\(model.productionCountries?.first ?? ""), \(model.releaseDate?.transformDateToYearString() ?? "")"
            self?.genresTitleLabel.text = "\(model.genres?.joined(separator: ", ") ?? "")"
            self?.reatingLabel.text = "\(String(localized: "RATING_TITLE")): \(model.rating ?? 0)"
            self?.overviewLabel.text = model.overview
            if let navigationTitle = self?.navigationItem.titleView as? NavigationTitleView, let title = model.title {
                navigationTitle.changeTitle(with: title)
            }
            
            if model.hasVideo ?? false {
                self?.videoButtonView.isHidden = false
            }
        }
        
        self.presenter.getMoviesImage(imagePath: model.imageUrl, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.view.hideLoader()
                if let image {
                    self?.posterImageView.image = image
                }
            }
        })
    }
        
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: String(localized: "ERROR_ALERT_TITLE"), message: message)
        }
    }
}
