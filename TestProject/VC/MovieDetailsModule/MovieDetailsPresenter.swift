//
//  MovieDetailsPresenter.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation
import UIKit

protocol MovieDetailsPresenterProtocol: AnyObject {
    func getMovieModel()
    func getMoviesImage(imagePath: String?, completion: @escaping (UIImage?) -> Void)
    func didSelectImage(image: UIImage?)
    func didSeclectVideo(trailerKey: String?)
}

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    weak var view: MovieDetailsVCProtocol?
    private let router: MovieDetailsRouterProtocol
    private let viewModel: MovieDetailsModelProtocol
    
    init(view: MovieDetailsVCProtocol?, router: MovieDetailsRouterProtocol, viewModel: MovieDetailsModelProtocol) {
        self.view = view
        self.router = router
        self.viewModel = viewModel
    }
    
    func getMovieModel() {
        self.view?.showLoader()
        self.viewModel.fetchMovieDetails { [weak self] result in
            switch result {
            case .success(var model):
                self?.viewModel.getMovieTrailerId { result in
                    switch result {
                    case .success(let trailerModel):
                        guard let key = trailerModel?.key else {
                            print("Key for play trailer not found")
                            model.hasVideo = false
                            return
                        }
                        model.trailerKey = key
                        model.hasVideo = true
                    default: break
                    }
                    self?.view?.getModel(model: model)
                }
               
            case .failure(let error):
                self?.view?.showUnavaliableView()
                self?.view?.showError(error.localizedDescription)
            }
            self?.view?.hideLoader()
        }
    }
    
    func getMoviesImage(imagePath: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = imagePath else {
            completion(nil)
            return
        }
        self.viewModel.getMovieImage(imagePath: urlString) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func didSelectImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.router.navigateToImageZoomView(image: image)
        }
    }
    
    func didSeclectVideo(trailerKey: String?) {
        DispatchQueue.main.async { [weak self] in
            guard Reachability.shared.isConnected else {
                self?.view?.showError(String(localized: "NO_INTERNET_CONNECTION"))
                return
            }
            
            guard let trailerKey else {
                self?.view?.showError(NetworkError.noData.localizedDescription)
                return
            }
            self?.router.showTrailer(key: trailerKey)
        }
    }
}
