//
//  DiscoverModel.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

struct DiscoverModel {
    struct Request {
        var genreIds: String?
        var page: Int?
        
        func parameters() -> [String: Any]? {
            return [
                "api_key": API.key,
                "page": page ?? 1,
                "with_genres": genreIds ?? "10749",
                "language": "en-US"
            ]
        }
    }
}
