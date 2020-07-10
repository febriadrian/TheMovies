//
//  DiscoverModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

struct DiscoverModel {
    struct Request {
        var genreIds: String?
        var page: Int?

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": page ?? 1,
                "with_genres": genreIds ?? "10749",
                "language": "en-US"
            ]
        }
    }

    struct ViewModel {
        var id: Int
        var posterUrl: String
        var voteAverage: String
    }
}
