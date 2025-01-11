//
//  MovieDetailsRouter.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import UIKit
import AVKit

protocol MovieDetailsRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToImageZoomView(image: UIImage?)
    func showTrailer(key: String)
}

final class MovieDetailsRouter: MovieDetailsRouterProtocol {
    var viewController: UIViewController?
    
    func navigateToImageZoomView(image: UIImage?) {
        let vc = MovieViewBuilder.setupMovieDetailsModule(image: image)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        self.viewController?.present(vc, animated: true)
    }
    
    func showTrailer(key: String) {
        let vc =  MovieViewBuilder.setupTrailerModule(key: key)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        self.viewController?.present(vc, animated: true)
    }
}
