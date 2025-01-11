//
//  MovieListPresenter.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import Foundation
import UIKit

protocol MovieListPresenterProtocol: AnyObject {
    var filterOptions: [(type: SortType, value: Bool)] { get }
    func fetchData()
    func getImage(imagePath: String, completion: @escaping ( UIImage? ) -> Void)
    func didSelectMovie(index: Int)
    func refreshData()
    func sortData(with type: SortType)
    func showFilterView()
}

enum SortType: String {
    case dateIncreasing = "FILTER_OPTION_DATE_OLD"
    case dateDecreasing = "FILTER_OPTION_DATE_NEWEST"
    case rateIncreasing = "FILTER_OPTION_RATING_BOTTOM"
    case rateDecreasing = "FILTER_OPTION_RATING_TOP"
    
    var localized: String {
          return NSLocalizedString(self.rawValue, comment: "")
      }
}

final class MovieListPresenter: MovieListPresenterProtocol {
    weak var view: MovieListVCProtocol?
    private let router: MoviesListRouterProtocol
    private let viewModel: MoviesListViewModelProtocol
    
    private var allMovies: [MoviesListModel] = []
    private var currentPage = 1
    private var isLoading: Bool = false
    
    var filterOptions: [(type: SortType, value: Bool)] = [
        (type: SortType.dateIncreasing, value: false),
        (type: SortType.dateDecreasing, value: true),
        (type: SortType.rateIncreasing, value: false),
        (type: SortType.rateDecreasing, value: false),
    ]
    
    init(view: MovieListVCProtocol?, router: MoviesListRouterProtocol, viewModel: MoviesListViewModelProtocol) {
        self.view = view
        self.router = router
        self.viewModel = viewModel
    }
    
    func fetchData() {
        guard !isLoading else { return }
        self.isLoading = true
        if currentPage == 1 {
            self.view?.showLoader()
        }
        viewModel.fetchMoviesList(currentPage: currentPage) { result in
            switch result {
            case .success(let movies):
                self.allMovies.append(contentsOf: movies)
            
                if let currentFilterType = self.filterOptions.first(where: { $0.value })?.type {
                    self.sortData(with: currentFilterType)
                } else {
                    self.view?.getMovieList(movies)
                }
                self.currentPage += 1
            case .failure(let error):
                if self.currentPage == 1 {
                    self.view?.showUnavaliableView()
                }
                self.view?.showError(error.localizedDescription)
            }
            
            self.view?.hideLoader()
            self.isLoading = false
        }
    }
    
    func getImage(imagePath: String, completion: @escaping ( UIImage? ) -> Void) {
        viewModel.getMovieImage(imagePath: imagePath) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func refreshData() {
        self.allMovies.removeAll()
        self.currentPage = 1
        fetchData()
    }
    
    func sortData(with type: SortType) {
        if let previousSelectedType = filterOptions.first(where: { $0.value })?.type,
           let index = filterOptions.firstIndex(where: { $0.type == previousSelectedType }) {
            filterOptions[index].value = false
        }
        
        if let index = filterOptions.firstIndex(where: { $0.type == type }) {
            filterOptions[index].value = true
        }
        
        switch type {
        case .dateIncreasing:
            self.allMovies.sort { $0.releaseDate?.dateFromString() ?? Date() < $1.releaseDate?.dateFromString() ?? Date() }
        case .dateDecreasing:
            self.allMovies.sort { $0.releaseDate?.dateFromString() ?? Date() > $1.releaseDate?.dateFromString() ?? Date() }
        case .rateIncreasing:
            self.allMovies.sort { $0.rating ?? 0 < $1.rating ?? 0 }
        case .rateDecreasing:
            self.allMovies.sort { $0.rating ?? 0 > $1.rating ?? 0 }
        }
        
        self.view?.getMovieList(self.allMovies)
    }
    
    func didSelectMovie(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard Reachability.shared.isConnected else {
                self?.view?.showError(String(localized: "NO_INTERNET_CONNECTION"))
                return
            }
            if let id = self?.allMovies[index].id {
                self?.router.navigateToMovieDetails(with: id)
            }
        }
    }
    
    func showFilterView() {
        let actionSheet = UIAlertController(title: String(localized: "FILTER_TITLE"), message: String(localized: "FILTER_DESCRIPTION"), preferredStyle: .actionSheet)
        
        for (type, value) in self.filterOptions {
            let action = UIAlertAction(title: type.localized, style: .default) { _ in
                self.sortData(with: type)
            }
            
            action.setValue(UIColor(named: "highlightedOrange"), forKey: "titleTextColor")
            
            if value {
                action.setValue(true, forKey: "checked")
            }
            
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "FILTER_CANCEL_BUTTON_TITLE"), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(cancelAction)
        
        self.router.viewController?.present(actionSheet, animated: true, completion: nil)
    }
}
