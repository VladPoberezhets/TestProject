//
//  MovieDetailDTO.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 10.01.2025.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let backdropPath: String?
    let genres: [GenreDTO]?
    let posterPath: String?
    let productionCountries: [ProductionCountriesDTO]?
    let releaseDate: String?
    let hasVideo: Bool?
    let overview: String?
    let title: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres, overview
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case hasVideo = "video"
        case title = "original_title"
        case rating = "vote_average"
    }
}

struct ProductionCountriesDTO: Decodable {
    let name: String?
}
