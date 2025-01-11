//
//  MovieListViewModel.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import Foundation
import UIKit

protocol MoviesListViewModelProtocol: BaseViewModelProtocol {
    func fetchMoviesList(currentPage: Int, completion: @escaping (Result<[MoviesListModel], Error>) -> Void)
}

final class MovieListViewModel: BaseViewModel, MoviesListViewModelProtocol {
    func fetchMoviesList(currentPage: Int, completion: @escaping (Result<[MoviesListModel], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetchMovies(currentPage: currentPage) { result in
                switch result {
                case .success(let moviesResponse):
                    if let movies = moviesResponse?.movies {
                        let moviesModel: [MoviesListModel]? = movies.compactMap({ movie in
                            MoviesListModel(id: movie?.id,
                                       title: movie?.originalTitle,
                                       rating: movie?.voteAverage,
                                       genre: movie?.genres?.compactMap { $0.name },
                                       releaseDate: movie?.releaseDate,
                                       imageUrl: movie?.backdropPath)
                        })
                        completion(.success(moviesModel ?? []))
                        print("Success get movies list")
                    } else {
                        completion(.failure(NetworkError.noData))
                        print("Failed get movies list with error: \(NetworkError.noData.localizedDescription)")
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("Failed get movies list with error: \(error.localizedDescription)")
                }
            }
        }
    }
}
