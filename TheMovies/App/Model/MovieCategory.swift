//
//  MovieCategory.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

enum MovieCategory {
    case popular
    case playing
    case upcoming
    case toprated
}

extension MovieCategory{
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .playing:
            return "Playing"
        case .upcoming:
            return "Upcoming"
        case .toprated:
            return "TopRated"
        }
    }
}
