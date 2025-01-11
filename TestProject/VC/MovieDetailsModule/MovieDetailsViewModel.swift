//
//  MovieDetailsViewModel.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation
import UIKit

protocol MovieDetailsModelProtocol: BaseViewModelProtocol {
    func fetchMovieDetails(completion: @escaping (Result<MovieDetailModel, Error>) -> Void)
    func getMovieTrailerId(completion: @escaping (Result<MovieTrailerModel?, Error>) -> Void)
}

final class MovieDetailsViewModel: BaseViewModel, MovieDetailsModelProtocol {
    private var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchMovieDetails(completion: @escaping (Result<MovieDetailModel, any Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetchMovieDetails(id: self.id) { result in
                switch result {
                case .success(let movie):
                    let model = MovieDetailModel(title: movie?.title, imageUrl: movie?.backdropPath, genres: movie?.genres?.map({ String($0.name ?? "") }), productionCountries: movie?.productionCountries?.map({ String($0.name ?? "") }), releaseDate: movie?.releaseDate, hasVideo: movie?.hasVideo, overview: movie?.overview, rating: movie?.rating)
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getMovieTrailerId(completion: @escaping (Result<MovieTrailerModel?, any Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.getMovieTrailerId(id: self.id) { result in
                switch result {
                case .success(let movieTrailer):
                    guard let movieTrailerKey = movieTrailer?.movieTrailersList.first(where: { $0.site.uppercased() == "YOUTUBE" })?.key else { return }
                    let model = MovieTrailerModel(key: movieTrailerKey)
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
