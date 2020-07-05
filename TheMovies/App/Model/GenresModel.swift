//
//  GenresModel.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

struct GenresModel {
    struct Request {
        func parameters() -> [String: Any]? {
            return [
                "api_key": API.key
            ]
        }
    }

    struct Response {
        var genres: [Genres]?

        init(data: JSON?) {
            if let items = data?["genres"].array {
                self.genres = items.map { Genres(data: JSON($0.object)) }
            }
        }

        struct Genres {
            var id: Int?
            var name: String?

            init(data: JSON?) {
                self.id = data?["id"].int
                self.name = data?["name"].string
            }
        }
    }
}
