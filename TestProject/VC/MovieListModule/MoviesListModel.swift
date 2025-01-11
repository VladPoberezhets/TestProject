//
//  MovieModel.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 09.01.2025.
//

import Foundation

struct MoviesListModel: Hashable {
    let id: Int?
    let title: String?
    let rating: Double?
    let genre: [String]?
    let releaseDate: String?
    let imageUrl: String?
    
    static func == (lhs: MoviesListModel, rhs: MoviesListModel) -> Bool {
        return lhs.id == rhs.id
    }
}
