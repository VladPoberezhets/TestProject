//
//  MovieModelsDTO.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation

struct MovieModelsDTO: Decodable {
    let page: Int?
    let movies: [MovieDTO?]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

// MARK: - Result
struct MovieDTO: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let genres: [GenreDTO]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let productionCompanies: [ProductionCompanyDTO]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case genres
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case productionCompanies = "production_companies"
    }
}

struct GenreDTO: Decodable {
    let id: Int?
    let name: String?
}


struct ProductionCompanyDTO: Decodable {
    let id: Int?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case country = "origin_country"
    }
}
