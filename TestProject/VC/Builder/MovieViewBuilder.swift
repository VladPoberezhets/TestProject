//
//  MovieViewBuilder.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation
import UIKit

final class MovieViewBuilder {
    static func setupMovieListModule() -> UINavigationController {
        let view = MovieListVC()
        let viewModel = MovieListViewModel()
        let router = MoviesListRouter()
        let presenter = MovieListPresenter(view: view, router: router, viewModel: viewModel)
        
        view.setupPresenter(presenter)
        
        let navigationController = UINavigationController(rootViewController: view)
        router.viewController = navigationController
        
        return navigationController
    }
    
    static func setupMovieDetailsModule(index: Int) -> UIViewController {
        let view = MovieDetailsVC()
        let viewModel = MovieDetailsViewModel(id: index)
        let router = MovieDetailsRouter()
        let presenter = MovieDetailsPresenter(view: view, router: router, viewModel: viewModel)

        view.setupPresenter(presenter)
        router.viewController = view

        return view
    }
    
    static func setupMovieDetailsModule(image: UIImage?) -> UIViewController {
        let view = ImageViewZoomVC(image: image)
        return view
    }
    
    static func setupTrailerModule(key: String) -> UIViewController {
        let vc = MovieTrailerVC(videoKey: key)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        return vc
    }
}
