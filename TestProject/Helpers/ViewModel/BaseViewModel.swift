//
//  BaseViewModel.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import UIKit

protocol BaseViewModelProtocol {
    func getMovieImage(imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

class BaseViewModel: BaseViewModelProtocol {
    func getMovieImage(imagePath: String, completion: @escaping (Result<UIImage?, any Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            CacheManager.shared.loadImage(with: imagePath, completion: { image in
                if image == nil {
                    NetworkManager.shared.getMovieImage(imagePath: imagePath) { result in
                        switch result {
                        case .success(let image):
                            CacheManager.shared.cacheImage(image, with: imagePath)
                            completion(.success(image))
                            print("Success get movie image")
                        case .failure(let error):
                            completion(.failure(error))
                            print("Failed get movie image with errr: \(error.localizedDescription)")
                        }
                    }
                } else {
                    completion(.success(image))
                    print("Success get movie image from cache")
                }
            })
        }
    }
}
