//
//  MoviesListRouter.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import Foundation
import UIKit

protocol MoviesListRouterProtocol {
    var viewController: UINavigationController? { get set }
    func navigateToMovieDetails(with id: Int)
}

final class MoviesListRouter: MoviesListRouterProtocol {
    weak var viewController: UINavigationController?
    
    func navigateToMovieDetails(with id: Int) {
        let vc = MovieViewBuilder.setupMovieDetailsModule(index: id)
        vc.modalPresentationStyle = .fullScreen
        viewController?.pushViewController(vc, animated: true)
    }
}

