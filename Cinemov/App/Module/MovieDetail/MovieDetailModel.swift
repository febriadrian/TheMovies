//
//  MovieDetailModel.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import SwiftyJSON

struct MovieDetailModel {
    struct Request {
        var id: Int

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "language": "en-US",
                "append_to_response": "credits,similar,reviews"
            ]
        }
    }

    struct Response {
        var title: String?
        var originalTitle: String?
        var tagline: String?
        var overview: String?
        var releaseDate: String?
        var backdropPath: String?
        var posterPath: String?
        var homepage: String?
        var id: Int?
        var runtime: Int?
        var budget: Int?
        var revenue: Int?
        var voteAverage: Double?
        var genres: [Others]?
        var prodCompanies: [Others]?
        var prodCountries: [Others]?
        var credits: Credits?
        var similar: MoviesModel.Response?
        var reviews: Reviews?

        init(data: JSON?) {
            self.title = data?["title"].string
            self.originalTitle = data?["original_title"].string
            self.tagline = data?["tagline"].string
            self.overview = data?["overview"].string
            self.releaseDate = data?["release_date"].string
            self.backdropPath = data?["backdrop_path"].string
            self.posterPath = data?["poster_path"].string
            self.homepage = data?["homepage"].string
            self.id = data?["id"].int
            self.runtime = data?["runtime"].int
            self.budget = data?["budget"].int
            self.revenue = data?["revenue"].int
            self.voteAverage = data?["vote_average"].double

            if let items = data?["genres"].array {
                self.genres = items.map { Others(data: JSON($0.object)) }
            }

            if let items = data?["production_companies"].array {
                self.prodCompanies = items.map { Others(data: JSON($0.object)) }
            }

            if let items = data?["production_countries"].array {
                self.prodCountries = items.map { Others(data: JSON($0.object)) }
            }

            if let dict = data?["credits"].dictionaryObject {
                self.credits = Credits(data: JSON(dict))
            }

            if let dict = data?["similar"].dictionaryObject {
                self.similar = MoviesModel.Response(data: JSON(dict))
            }

            if let dict = data?["reviews"].dictionaryObject {
                self.reviews = Reviews(data: JSON(dict))
            }
        }

        struct Others {
            var name: String?

            init(data: JSON?) {
                self.name = data?["name"].string
            }
        }

        struct Credits {
            var cast: [Detail]?
            var crew: [Detail]?

            init(data: JSON?) {
                if let items = data?["cast"].array {
                    self.cast = items.map { Detail(data: JSON($0.object)) }
                }

                if let items = data?["crew"].array {
                    self.crew = items.map { Detail(data: JSON($0.object)) }
                }
            }

            struct Detail {
                var name: String?
                var profilePath: String?
                var character: String?
                var job: String?

                init(data: JSON?) {
                    self.name = data?["name"].string
                    self.profilePath = data?["profile_path"].string
                    self.character = data?["character"].string
                    self.job = data?["job"].string
                }
            }
        }

        struct Reviews {
            var results: [Results]?

            init(data: JSON?) {
                if let items = data?["results"].array {
                    self.results = items.map { Results(data: JSON($0.object)) }
                }
            }

            struct Results {
                var author: String?
                var content: String?

                init(data: JSON?) {
                    self.author = data?["author"].string
                    self.content = data?["content"].string
                }
            }
        }
    }

    struct MVDetailModel {
        var id: Int
        var title: String
        var originalTitle: String
        var tagline: String
        var overview: String
        var releaseDate: String
        var homepage: String
        var runtime: String
        var budget: String
        var revenue: String
        var voteAverage: String
        var genres: String
        var prodCompanies: String
        var prodCountries: String
        var backdropPath: String
        var posterPath: String
        var favorite: Bool
    }

    struct PeopleModel {
        var name: String
        var profilePath: String
        var character: String
        var job: String
    }

    struct SimilarModel {
        var id: Int
        var title: String
        var posterPath: String
        var voteAverage: String
        var overview: String
        var releaseDate: String
    }

    struct ReviewModel {
        var author: String
        var content: String
    }
}
