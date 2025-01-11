//
//  MovieListVC.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import UIKit

protocol MovieListVCProtocol: BaseUIViewControllerProtocol {
    func getMovieList(_ movies: [MoviesListModel])
    func showError(_ message: String)
}

final class MovieListVC: BaseUIViewController {
    private(set) var presenter: MovieListPresenterProtocol!
    
    private var moviesArray: [MoviesListModel]?
    private var filteredMovies: [MoviesListModel]?
    private var searchTextTimer: Timer?
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.barTintColor = UIColor(named: "backgroundColor")
        view.tintColor = UIColor(named: "highlightedOrange")
        view.searchTextField.textColor = UIColor.black
        view.placeholder = String(localized: "SEARCH_BAR_PLACEHOLDER_TITLE")
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 210)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .always
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.refreshControl = UIRefreshControl()
        view.refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        view.delegate = self
        view.dataSource = self
        view.register(MovieListViewCell.self, forCellWithReuseIdentifier: MovieListViewCell.identifier)
        (view.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        return view
    }()
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.setupNavigationTitle(image: UIImage(named: "navigationImage"), title: String(localized: "HEADER_TITLE"), buttonPosition: .right, addButtonAction: #selector(showFilterView))
        setupSearchBar()
        setupCollectionView()
        presenter.fetchData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func setupSearchBar() {
        self.view.addSubview(self.searchBar)

        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.searchBar.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    @objc private func refreshAction() {
        self.presenter.refreshData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func showFilterView() {
        self.presenter.showFilterView()
    }
    
    
    @objc private func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension MovieListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextTimer?.invalidate()
        searchTextTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            if searchText.isEmpty {
                self.filteredMovies = self.moviesArray
            } else {
                self.filteredMovies = self.moviesArray?.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
            }
            self.collectionView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MovieListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListViewCell.identifier, for: indexPath) as? MovieListViewCell, let model = self.filteredMovies?[indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.setup(model: model, presenter: presenter)
        return cell
    }
}

extension MovieListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 32
        return CGSize(width: width, height: 210)
    }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 20
     }
}

extension MovieListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.didSelectMovie(index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height - 200 && self.filteredMovies?.count == self.moviesArray?.count {
            presenter.fetchData()
        }
    }
}


extension MovieListVC {
    func setupPresenter(_ presenter: MovieListPresenterProtocol) {
        self.presenter = presenter
    }
}

extension MovieListVC: MovieListVCProtocol {
    func getMovieList(_ movies: [MoviesListModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.filteredMovies = movies
            self?.moviesArray = movies
            self?.collectionView.reloadData()
        }
    }
        
    func showError(_ message: String) {
        self.showAlert(title: String(localized: "ERROR_ALERT_TITLE"), message: message)
    }
}

