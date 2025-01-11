//
//  MovieTrailerDTO.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation

struct MovieTrailerDTO: Decodable {
    let id: Int
    let movieTrailersList: [MovieTrailersListDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case movieTrailersList = "results"
    }
}

struct MovieTrailersListDTO: Decodable {
    let key: String
    let site: String

    enum CodingKeys: String, CodingKey {
        case key, site
    }
}
