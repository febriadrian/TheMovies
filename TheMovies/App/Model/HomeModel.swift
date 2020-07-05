//
//  MoviesModel.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

struct HomeModel {
    struct Request {
        var page: Int?

        func parameters() -> [String: Any]? {
            return [
                "api_key": API.key,
                "page": page ?? 1,
                "language": "en-US"
            ]
        }
    }

    struct Response {
        var page: Int?
        var totalResults: Int?
        var totalPages: Int?
        var results: [Results]?

        init(data: JSON?) {
            self.page = data?["page"].int
            self.totalResults = data?["total_results"].int
            self.totalPages = data?["total_pages"].int

            if let items = data?["results"].array {
                self.results = items.map { Results(data: JSON($0.object)) }
            }
        }

        struct Results {
            var id: Int?
            var title: String?
            var posterPath: String?
            var overview: String?
            var releaseDate: String?
            var voteAverage: Double?

            init(data: JSON?) {
                self.id = data?["id"].int
                self.title = data?["title"].string
                self.posterPath = data?["poster_path"].string
                self.overview = data?["overview"].string
                self.releaseDate = data?["release_date"].string
                self.voteAverage = data?["vote_average"].double
            }
        }
    }

    struct Movies {
        var id: Int
        var title: String
        var posterUrl: String
        var voteAverage: String
        var overview: String? = nil
        var releaseDate: String? = nil
    }
}
